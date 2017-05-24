#! /usr/bin/env python

# Imports.
import sys, argparse, math, pdb

# Parse arguments.
parser = argparse.ArgumentParser(formatter_class=
                                 argparse.ArgumentDefaultsHelpFormatter)
parser.add_argument("-P", "--price", type=int,
                    help="House price (S)", required=True)
parser.add_argument("-D", "--down_payment", type=float, default=0,
                    help="Down payment ($)", required=True)
parser.add_argument("-I", "--interest_rate", type=float,
                    help="Annual interest rate", required=True)
parser.add_argument("-L", "--loan_term", type=int, default=30,
                    help="Loan period (yrs)", required=False)
parser.add_argument("-C", "--check", action='store_true',
                    help="Check monthly payment computation.")

args = parser.parse_args()
# Assign to variables.
# Initial principal.
P0 = args.price - args.down_payment
# Monthly interest rate.
if (args.interest_rate > 1):
    i = args.interest_rate/100.0/12.0
else:
    i = args.interest_rate/12.0
# Loan term in months.
N = args.loan_term*12

# Compute monthly payment.
M = P0*i*(1+i)**N / ((1+i)**N - 1)
# Check computation, if desired.
if (args.check):
    print "Checking monthly payment computation...",
    P_rem = P0
    for j in range(1,N+1):
        P_rem = P_rem*(1+i) - M
    if (abs(P_rem) < 1e-6):
        print "OK."
    else:
        print "not OK!"
        raise ValueError("Monthly payment computation is wrong.")

# Compute total paid.
total = M*N + args.down_payment
if (args.check):
    print "Checking total paid...",
    tot_check = P0*i*N * (1+i)**N / ((1+i)**N - 1) + args.down_payment
    if (abs(total-tot_check) < 1e-6):
        print "OK."
    else:
        print "not OK!"
        raise ValueError("Total paid computation is wrong.")

# Compute total interest paid.
tot_int = total - args.price
if (args.check):
    print "Checking total interest...",
    ti_check = P0*(i*N*(1+i)**N/((1+i)**N - 1) - 1)
    if (abs(tot_int - ti_check) < 1e-6):
        print "OK."
    else:
        print "not OK!"
        raise ValueError("Total interest computation is wrong.")

# Print results.
print "House price:\t\t$%d" % args.price
print "Down payment:\t\t$%d"% args.down_payment
print "Interest rate:\t\t %.3f%%" % (args.interest_rate*100)
print "Monthly payment:\t$%.2f" % M
print "Total paid:\t\t$%.2f" % total
print "Total interest paid:\t$%.2f" % tot_int

# End of file
