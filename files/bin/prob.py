from __future__ import division
from math import factorial


def comb(k, n):
    """Number of ways of choosing k things from n total"""
    return factorial(n)//(factorial(k)*factorial(n-k))


def hyperg(k, n, K, N):
    """
    Probability of drawing exactly k objects in n draws,
    given that there are K objects in N total
    """
    return comb(k, K)*comb(n-k, N-K)/comb(n, N)


def prob_k_or_more(k, n, K, N):
    """
    Probability of choosing k or more objects in n draws,
    given that there are K objects in N total
    """
    if k == K:
        return hyperg(K, n, K, N)
    else:
        return hyperg(k, n, K, N) + prob_k_or_more(k+1, n, K, N)


def prob_k_or_fewer(k, n, K, N):
    """
    Probability of choosing k or fewer objects in n draws,
    given that there are K objects in N total
    """
    if k == 0:
        return hyperg(0, n, K, N)
    else:
        return hyperg(k, n, K, N) + prob_k_or_fewer(k-1, n, K, N)
