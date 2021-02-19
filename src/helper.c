/*
	Place for any additional C code needed
*/
void load_unload_stack(int reg_nb){
	if (reg_nb == 4)
	{
		printf("STMFD SP!, {R4} \n");	//check here
	}
	else if (reg_nb >4)
	{
		printf("STMFD SP!, {R4-R%d} \n",reg_nb); //check here
	}
}