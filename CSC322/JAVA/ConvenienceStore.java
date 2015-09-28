////Joshua Pinos
////Albert Chan
////CSC 322
////Assignment 4

public class ConvenienceStore extends Business {

	public ConvenienceStore(int accountNumber, String name) {
		super(accountNumber, name);
	}

	@Override
	public double getTaxDue() {
		double tax=this.getPrimaryIncome()*0.07;
		return tax;
	}
	@Override
	public String report(){
		String str="Account Number: "+Integer.toString(this.getAccountNumber())+" ("+this.getName()+")"+"\n";
	    str=str+"Business Type: Convenience Store\n";
	    str=str+"Newspaper Income: $"+String.format("%.2f",this.getSecondaryIncome())+"\n";
	    str=str+"Non-Newspaper Income: $"+String.format("%.2f",this.getPrimaryIncome())+"\n";
	    str=str+"Total Income: $"+String.format("%.2f",this.getPrimaryIncome()+this.getSecondaryIncome())+"\n";
	    str=str+"Total Tax Due: $"+String.format("%.2f",this.getTaxDue());
		return str;
	}

}
