#!/usr/bin/env python

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
		self.__ded_met = False
		# Is OOP maximum met?
		self.__oop_met = False
		# total cost (make not directly modifiable?)	
		self.__cost = 0
		# Lists for tracking visit cost and amount paid.
		self.__vcost = []
		self.__vpaid = []
		# total number of visits
		self.__num_visits = 0

	def add_visit(self, visit):
	
		# total paid for visit.
		visit_paid = 0	

		# If OOP max is met, nothing is paid.
		if self.__oop_met:
			pass
		else:		
			# If deductible is met:
			if self.__ded_met:
				visit_paid += self.copay_ad[visit.visit_type]
				visit_paid += visit.cost * self.coinsurance
			else:
				visit_paid += self.copay_bd[visit.visit_type]
				if (self.deductible < (visit.cost + self.__cost)):
					over_ded = (visit.cost + self.__cost) - self.deductible
					visit_paid += (visit.cost - over_ded) + self.coinsurance*over_ded
					self.__ded_met = True
				else:
					visit_paid += visit.cost
		
		# Check again if OOP max is met, subtract difference if so.
		if (not self.__oop_met and self.__cost > self.oop_max):
			visit_paid = self.oop_max - self.__cost
			self.__cost = self.oop_max
			self.__oop_met = True

		# Append to visit cost/paid lists.
		self.__vcost.append(visit.cost)
		self.__vpaid.append(visit_paid)

		# Final stuff.
		self.__cost += visit_paid
		self.__num_visits += 1


	def print_annual_cost(self):
		total_cost = self.__cost + self.premium*12.0
		
		# Print information.
		print "Total costs of %s:" % self.name
		print "\tPremiums:\t\t%.2f" % (self.premium*12.0)
		print "\tVisits (%i):\t\t%.2f" % (self.__num_visits, self.__cost)
		print "\t---------------------------------"
		print "\tTotal annual cost:\t%.2f\n" % total_cost

	def print_visit_breakdown(self):
		for vp,vc in zip(self.__vpaid,self.__vcost):
			print 
		
# Main code --------------------------------------------------------------------
# Set up plans
iyc_plan = Plan(name="It's Your Choice Health Plan", deductible=217, \
                copay_bd=[15,25], copay_ad=[15,25], hsa=False, \
                premium=219, oop_max=2500, coinsurance=0.1)
hdhp_plan = Plan(name="It's Your Choice HDHP", deductible=3000, \
                 copay_bd=[0,0], copay_ad=[15,25], hsa=True, \
                 hsa_amount=1500, premium=82, oop_max=5000, \
                 coinsurance=0.1)

# Add visits.
for ii in range(0,20):
	new_visit = Visit(visit_type="normal", cost=200)
	iyc_plan.add_visit(new_visit)
	hdhp_plan.add_visit(new_visit)

# Print results.
iyc_plan.print_annual_cost()
hdhp_plan.print_annual_cost()
