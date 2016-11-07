#!/usr/bin/env python

# Imports
import matplotlib.pyplot as plt
import copy
from scipy.stats import chi2
import numpy as np
import pdb

# Notes:
#	co-pays don't count towards deductible.
#	co-pays do count towards OOPL.
#	deductible counts towards OOPL.

class Visit:
	"""Model for provider visits."""
	def __init__(self, cost, visit_type="normal", description=None):

		# Type of visit.
		v_types = ["normal","specialist"]
		if (visit_type in v_types):
			self.visit_type = visit_type
		else:
			raise ValueError("visit_type should be \"normal\" or \"specialist\".")

		# Visit cost ($)
		if (cost >= 0):
			self.cost = cost
		else:
			raise ValueError("Cost should be >= 0.")

		# Visit description.
		self.description = description

class Plan:
	"""Model for health care plan."""
	def __init__(self, name, deductible, copay_bd, copay_ad, \
	             premium, oop_max, hsa, coinsurance, hsa_amount=0):
		self.name = name # plan name
		self.deductible = deductible # deductible amount ($)
		# copay before deductible is met ($)
		self.copay_bd = {"normal": copay_bd[0], "specialist": copay_bd[1]}
		# copay after deductible is met ($)
		self.copay_ad = {"normal": copay_ad[0], "specialist": copay_ad[1]}
		self.hsa = hsa # is there an HSA? (boolean)
		if (not hsa and hsa_amount != 0):
			self.hsa_amount = 0
		else:
			self.hsa_amount = hsa_amount
		self.coinsurance = coinsurance # Coinsurance (fraction).
		self.premium = premium # monthly premium ($)
		self.oop_max = oop_max # out-of-pocket maximum ($)

		# Private variables ----------------
		# Is deductible met?
		self._ded_met = False
		# Is OOP maximum met?
		self._oop_met = False
		# total cost (make not directly modifiable?)	
		self._cost = 0
		# Lists for tracking visit cost and amount paid.
		self.__vcost = []
		self.__vpaid = []
		# total number of visits
		self.__num_visits = 0

	def add_visit(self, visit):
	
		# total paid for visit.
		visit_paid = 0	
		# If OOP max is met, nothing is paid.
		if self._oop_met:
			pass
		else:		
			# If deductible is met:
			if self._ded_met:
				visit_paid += self.copay_ad[visit.visit_type]
				visit_paid += visit.cost * self.coinsurance
			else:
				visit_paid += self.copay_bd[visit.visit_type]
				if (self.deductible <= (visit.cost + self._cost)):
					over_ded = (visit.cost + self._cost) - self.deductible
					visit_paid += (visit.cost - over_ded) + self.coinsurance*over_ded
					self._ded_met = True
				else:
					visit_paid += visit.cost
	
		# Check again if OOP max is met, subtract difference if so.
		if ((not self._oop_met) and (self._cost + visit_paid) >= self.oop_max):
			visit_paid = self.oop_max - self._cost
			self._cost = self.oop_max
			self._oop_met = True

		# Use HSA funds if available.
		if (self.hsa and self.hsa_amount > 0):
			hsa_funds = min(visit_paid, self.hsa_amount)
			visit_paid -= hsa_funds
			self.hsa_amount -= hsa_funds

		# Append to visit cost/paid lists.
		self.__vcost.append(visit.cost)
		self.__vpaid.append(visit_paid)

		# Final stuff.
		self._cost += visit_paid
		self.__num_visits += 1

	def print_annual_cost(self):
		total_cost = self._cost + self.premium*12.0
		
		# Print information.
		print "Total costs of %s:" % self.name
		print "\tPremiums:\t\t%.2f" % (self.premium*12.0)
		print "\tVisits (%i):\t\t%.2f" % (self.__num_visits, self._cost)
		print "\t---------------------------------"
		print "\tTotal annual cost:\t%.2f\n" % total_cost

	def print_visit_breakdown(self):
		tot_paid = 0
		tot_cost = 0
		print("Visit\tPaid ($)\tCost ($)\tTot Paid ($)\tTot Cost ($)")
		print("--------------------------------------------------------------------")
		for i, (vp,vc) in enumerate(zip(self.__vpaid,self.__vcost)):
			tot_paid += vp; tot_cost += vc
			print("%d\t%.2f\t\t%.2f\t\t%.2f\t\t%.2f" % (i+1, vp, vc, tot_paid, tot_cost))
		print("") # newline	

	def gen_plot_series(self):
		paid = [self.premium*12]; benefits = [0]
		for vp,vc in zip(self.__vpaid, self.__vcost):
			paid.append(vp + paid[-1])
			benefits.append(vc + benefits[-1])

		return (paid, benefits)

	def print_info(self):
		print("Deductible met: %s" % self._ded_met)
		print("OOP met: %s" % self._oop_met)
		print("Self cost: %s" % str(self._cost))

def plot_cost_breakdown(plan_list, fname_prefix):

	# Colors
	col_list = ['blue','red','black','yellow']

	# Plot 1: benefits vs. paid -------------------------------
	# Set up plot figure
	fig = plt.figure(); ax = plt.gca()

	# Loop over plans
	for i,plan in enumerate(plan_list):
		paid, benefits = plan.gen_plot_series()
		plt.plot(paid, benefits, linewidth=2, color=col_list[i], label=plan.name)
		for j,xy in enumerate(zip(paid,benefits)):
			ann=(xy[0]-100, xy[1]+100)
			ax.annotate('%d' % j, xy=ann, fontsize=8, color=col_list[i])
	
	ax.set_xlabel('Cost ($)')
	ax.set_ylabel('Benefits ($)')
	ax.set_title(fname_prefix)
	plt.legend(loc='upper left', fontsize=10)
	fig.savefig('%s_benefits_vs_cost.png' % fname_prefix)
	plt.close()

	# Plot 2: paid vs. visit number. --------------------------
	fig = plt.figure(); ax = plt.gca()
	for i,plan in enumerate(plan_list):
		paid, benefits = plan.gen_plot_series()
		visit_nums = range(1,len(paid)+1)
		plt.plot(visit_nums, paid, linewidth=2, color=col_list[i], label=plan.name)
	ax.set_xlabel('Visit number')
	ax.set_ylabel('Cost ($)')
	ax.set_title(fname_prefix)
	plt.legend(loc='upper left', fontsize=10)
	fig.savefig('%s_cost_vs_visits.png' % fname_prefix)
	plt.close()

# Main code --------------------------------------------------------------------
# Set up plans
iyc_plan = Plan(name="It's Your Choice Health Plan", deductible=500, \
                copay_bd=[15,25], copay_ad=[15,25], hsa=False, \
                premium=219, oop_max=2500, coinsurance=0.1)
hdhp_plan = Plan(name="It's Your Choice HDHP", deductible=3000, \
                 copay_bd=[0,0], copay_ad=[15,25], hsa=True, \
                 hsa_amount=1500, premium=82, oop_max=5000, \
                 coinsurance=0.1)

# Make copies
iyc2 = copy.deepcopy(iyc_plan); iyc3 = copy.deepcopy(iyc_plan)
hdhp2 = copy.deepcopy(hdhp_plan); hdhp3 = copy.deepcopy(hdhp_plan)

# Model 1: many $200 visits. ----------------------------
# Add visits.
for ii in range(0,60):
	new_visit = Visit(visit_type="normal", cost=200)
	iyc_plan.add_visit(new_visit)
	hdhp_plan.add_visit(new_visit)

# Plots
plot_cost_breakdown([iyc_plan, hdhp_plan],"fixed_200")

# Model 2: many visits with Gaussian mean of 200 and
#          sigma of 200.
for ii in range(0,60):
	cost = np.random.normal(200,100)
	if (cost < 100): cost = 100
	new_visit = Visit(visit_type="normal", cost=cost)
	iyc2.add_visit(new_visit); hdhp2.add_visit(new_visit)
# Plots
plot_cost_breakdown([iyc2, hdhp2], "random_200")

# Model 3: trying to be most accurate.
# Use chi2 distribution with 3 DOF.
np.random.seed(4)
for ii in range(0,60):
	cost = np.random.chisquare(3,1)[0]*100
	if (cost < 100): cost = 100
	vtype_var = np.random.uniform(1)
	if (vtype_var < 0.3):
		vtype = "specialist"
	else:
		vtype = "normal"
	new_visit = Visit(visit_type=vtype, cost=cost)
	iyc3.add_visit(new_visit);
	hdhp3.add_visit(new_visit)
# Plots
plot_cost_breakdown([iyc3, hdhp3], "model3")
