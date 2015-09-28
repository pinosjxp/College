////Joshua Pinos
////Albert Chan
////CSC 322
////Assignment 4

import java.util.Vector;

public abstract class Business {
	private int accountNumber=0;
	private String name = null;
	private double primaryIncome=0;
	private double secondaryIncome=0;
	private static Vector<Business> b=new Vector<>();
	public Business(int accountNumber,String name){
		this.accountNumber=accountNumber;
		this.name=name;
		b.add(this);
	}
	public int getAccountNumber(){
		return this.accountNumber;
	}
	public void setAccountNumber(int accountNumber){
		this.accountNumber=accountNumber;
	}
	public String getName(){
		return this.name;
	}
	public void setName(String name){
		this.name=name;
	}
	public double getPrimaryIncome(){
		return this.primaryIncome;
	}
	public void addPrimaryIncome(double amount){
		this.primaryIncome=this.primaryIncome+amount;
	}
	public double getSecondaryIncome(){
		return this.secondaryIncome;
	}
	public void addSecondaryIncome(double amount){
		this.secondaryIncome=this.secondaryIncome+amount;
	}
	public abstract double getTaxDue();
	public String report(){
		String str="Account Number: "+"("+")"+"\n";
	    str=str+"Business Type: "+"\n";
	    str=str+"Primary Income: "+"\n";
	    str=str+"Secondary Income: "+"\n";
	    str=str+"Total Income: "+"\n";
	    str=str+"Total Tax Due: "+"\n";
		return str;
	}
	public static Business findBusiness(int accountNumber){
		boolean x=false;
		int i=0;
		Business r=null;
		while (!x && i<=b.size()){
			Business tmp = (Business) b.elementAt(i);
			if (tmp.getAccountNumber()==accountNumber){
				x=true;
				r=tmp;
			}
			i++;
		}
		return r;
	}
	public static Business [] getRegisteredBusinesses(){
		Business [] r= new Business[b.size()];
		return (Business[]) b.toArray(r);
	}
}
