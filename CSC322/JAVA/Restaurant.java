////Joshua Pinos
////Albert Chan
////CSC 322
////Assignment 4

public class Restaurant extends Business{

	public Restaurant(int accountNumber, String name) {
		super(accountNumber, name);
	}

	@Override
	public double getTaxDue() {
		double p=this.getPrimaryIncome();
		double s=this.getSecondaryIncome();
		double tax=0;
		if (s>p){
			tax=s*0.12+p*0.06+(s+p)*0.05;
		}
		else{
			tax=s*0.12+p*0.06;
		}
		return tax;
	}
	@Override
	public String report(){
		String str="Account Number: "+Integer.toString(this.getAccountNumber())+" ("+this.getName()+")"+"\n";
	    str=str+"Business Type: Restaurant\n";
	    str=str+"Food Income: $"+String.format("%.2f",this.getPrimaryIncome())+"\n";
	    str=str+"Alcoholic Income: $"+String.format("%.2f",this.getSecondaryIncome())+"\n";
	    str=str+"Total Reciepts: $"+String.format("%.2f",this.getPrimaryIncome()+this.getSecondaryIncome())+"\n";
	    str=str+"Total Tax Due: $"+String.format("%.2f",this.getTaxDue());
		return str;
	}
}
