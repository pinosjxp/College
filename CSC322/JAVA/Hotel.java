////Joshua Pinos
////Albert Chan
////CSC 322
////Assignment 4

public class Hotel extends Business{

	public Hotel(int accountNumber, String name) {
		super(accountNumber, name);
	}

	@Override
	public double getTaxDue() {
		double p=this.getPrimaryIncome();
		double s=this.getSecondaryIncome();
		double tax=0;
		if (p>s){
			tax=p*0.15+s*0.12;
		}
		else{
			tax=p*0.12+s*0.15;
		}
		return tax;
	}
	@Override
	public String report(){
		String str="Account Number: "+Integer.toString(this.getAccountNumber())+" ("+this.getName()+")"+"\n";
	    str=str+"Business Type: Hotel\n";
	    str=str+"Room Income: $"+String.format("%.2f",this.getPrimaryIncome())+"\n";
	    str=str+"Suite Income: $"+String.format("%.2f",this.getPrimaryIncome())+"\n";
	    str=str+"Total Income: $"+String.format("%.2f",this.getPrimaryIncome()+this.getSecondaryIncome())+"\n";
	    str=str+"Total Tax Due: $"+String.format("%.2f",this.getTaxDue());
		return str;
	}
}
