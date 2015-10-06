/*
* Author:      Joshua Pinos 
* Professor:   Chekad Sarami
* Class:       CSC 202
* Date:        6th of October, 2015
* Description: A simple fraction class, with the ability to display the fraction in its reduced and decimal form.
*/

#include <iostream>

/* Namespace for cout usage */
using namespace std;

/* Fraction class */
class Fraction {
/* Declare numerator and denominator variables */
private:
	int num, den;
public:
    /* Class function for printing out the reduced fraction */
	void reduced() {
		int g = gcd(num,den);
		cout << num / g << "/"<< den / g << endl;
	}
    /* Mutator function for setting numerator variable. */
	void setNum(int n) {num = n;}
    /* Mutator function for setting denominator variable. */
	void setDen(int d) {den = d;}
	/* Class function for finding greatest common denominator using Dijkstra's Algorithm (Recursive algorithm without expensive divide operation)*/
    int gcd(int m,int n) {
        /* Base Case */
		if (m == n)
			return m;
        /* Case 1 */
		else if (m > n)
			return gcd(m - n, n);
        /* Case 2 */
		else
			return gcd(m, n - m);
	}
    /* Class function for returning the decimal point representation (double) of the fraction */
	double getFloat(){return (double(num) / double(den));}
};
/* Main function for testing Fraction class */
int main() {
    /* Instantiate Fraction objects f1 and f2 */
	Fraction f1, f2;
    /* Sets Fraction object f1's numerator to 4 and denominator to 2 (Ie. 4/2) */
	f1.setNum(4);
	f1.setDen(2);
    /* Print out the Fraction object f1 in reduced format */
	f1.reduced();
    /* Print out the decimal representation of Fraction object f1 */
    cout<<f1.getFloat()<<endl;
    /* Sets Fraction class f1's numerator to 4 and denominator to 2 (I.e. 20/60) */
	f2.setNum(20);
	f2.setDen(60);
    /* Print out the Fraction object f2 in reduced format */
	f2.reduced();
    /* Print out the decimal representation of Fraction object f1 */
    cout<<f2.getFloat()<<endl;
    /* Exit program */
	return 0;
}
