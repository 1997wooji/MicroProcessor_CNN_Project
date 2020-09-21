#include "base.h"

//4086fdfc

//extern void adder (int *arr_in, int *arr_out, int arr_size, int *sum) ;

//#define rowSize 1080 //aSize is 
//#define ColumnSize 1920 //aSize is 
//#define resRowSize 540
//#define resColumnSize 960

//extern void loadImage(int (*imghex)[ColumnSize]);
//extern void Grayscale(char (*origin)[ColumnSize*4],int gray[rowSize+2][ColumnSize+2]);
//extern void convolution(int gray[rowSize+2][ColumnSize+2],int conv[rowSize][ColumnSize]);
//extern void maxpooling(int (*conv)[ColumnSize], int (*result)[resColumnSize]);
//extern int maxFormaxpooling(int a, int b, int c, int d);
extern void Relocation(void);
extern void Grayscale(void);
extern void Convolution(void);
extern void MaxPooling(void);

int main(void)

{
//   int init[rowSize][ColumnSize];
//   int gray[rowSize+2][ColumnSize+2];
//   int conv[rowSize][ColumnSize]; //convolution result convolution
//   int result[resRowSize][resColumnSize];

	 //loadImage(init);
   //Grayscale ((char (*) [ColumnSize*4])init, gray);
  // convolution(gray,conv);
   //maxpooling(conv,result);

	
	Relocation();
 	Grayscale();
	Convolution();
	MaxPooling();
	

int * result;
	
	result=0x70119590;
	printDecimal((*result));
	sendchar('\n');
	result=0x701198B0;	
	printDecimal((*result));
	sendchar('\n');
	result=0x701774B0;	
	printDecimal((*result));
	sendchar('\n');
	result=0x7011A080;	
	printDecimal((*result));
	
//0x70119590;//[100, 300] x=100 y=300 so we mul 960*300*4 + 100*4
//0x701198B0;//[300, 300]
//0x701774B0;//[300, 400]
//0x7011A080;//[800, 300]

	  _sys_exit(0);
}
