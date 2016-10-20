#!/usr/bin/env python

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
	def __init__(self, name, deductible, copay_bd, copay_ad, copay_special, \
	             premium, oop_max, hsa, hsa_amount=0):
		self.name = name # plan name
		self.deductible = deductible # deductible amount ($)
		self.copay_bd = copay_bd # copay before deductible is met ($)
		self.copay_ad = copay_ad # copay after deductible is met ($)
		self.copay_special = copay_special # copay for specialists ($)
		self.hsa = hsa # is there an HSA? (boolean)
		if (not hsa and hsa_amount != 0):
			self.hsa_amount = 0
		else:
			self.hsa_amount = hsa_amount
		self.premium = premium # monthly premium ($)
		self.oop_max = oop_max # out-of-pocket maximum ($)

		# Private variables ----------------
		# Is deductible met?
		self.__ded_met = False
		# Is OOP maximum met?
		self.__oop_met = False
		# total cost (make not directly modifiable?)	
		self.__cost = 0
		# Co-pay amounts
		self.__copay_cost = 0
		# total number of visits
		self.__visits = 0

	def add_visit(self, visit):
		# if not ded_met
		#	do something
		
		# if not oop_met
		#	do something
		
		# if specialist visit
		#	calculate co-pay cost
		self.__cost += visit.cost
		self.__visits += 1

	def print_annual_cost(self):
		total_cost = self.__cost + self.premium*12.0
		
		# Print information.
		print "Total costs of %s:" % self.name
		print "\tPremiums:\t\t%.2f" % (self.premium*12.0)
		print "\tVisits (%i):\t\t%.2f" % (self.__visits, self.__cost)
		print "\tCo-pays:\t\t%.2f" % self.__copay_cost
		print "\t---------------------------------"
		print "\tTotal annual cost:\t%.2f" % total_cost


# Main code
iyc_plan = Plan(name="It's Your Choice Health Plan", deductible=217, \
                copay_bd=15, copay_ad=15, copay_special=25, hsa=False, \
                premium=217)

iyc_plan.add_visit(Visit(visit_type="normal", cost=200))
iyc_plan.print_annual_cost()
