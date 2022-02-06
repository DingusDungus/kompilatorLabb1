class Factorial {
    public static void main(String[] a) {
	System.out.println(new Fac().ComputeFac(10));
    }
}

class Fac extends someClass {
    public int ComputeFac(int num, int[] someArray) {
	int num_aux;
	boolean testBool;
	while(num == someArray[2] && num_aux == 10){
	  System.out.println(a);
	}
	if (num < 1 || 1 > num && !testBool)
	    num_aux = 1;
	else
	    num_aux = num * (this.ComputeFac(num - 1));
	someArray[2] = num;
	return num_aux;
    }
}
