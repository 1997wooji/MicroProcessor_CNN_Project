#include "base.h"
#define rowSize 1080
#define ColumnSize 1920 
#define resRowSize 540
#define resColumnSize 960

void loadImage(int (*imghex)[ColumnSize]);
void Grayscale(char (*origin)[ColumnSize*4],int gray[rowSize+2][ColumnSize+2]);
void convolution(int gray[rowSize+2][ColumnSize+2],int conv[rowSize][ColumnSize]);
void maxpooling(int (*conv)[ColumnSize], int (*result)[resColumnSize]);

int main(void)
{
   int init[rowSize][ColumnSize];
   int gray[rowSize+2][ColumnSize+2];
   int conv[rowSize][ColumnSize]; 
   int result[resRowSize][resColumnSize];
   
   loadImage(init);
   Grayscale ((char (*) [ColumnSize*4])init, gray);
   convolution(gray,conv);
   maxpooling(conv,result);

	printDecimal(result[300][100]);
	sendchar('\n');
	printDecimal(result[300][300]);
	sendchar('\n');
	printDecimal(result[400][300]);
	sendchar('\n');
	printDecimal(result[300][800]);
   
   _sys_exit(0);
}

void loadImage(int (*imghex)[ColumnSize]){
   
   int *origin;
   int i,j;
   
   origin=0x40000000;

   for(i=0; i<rowSize ;i++){
      for(j=0; j<ColumnSize ;j++){   
         imghex[i][j]=(*origin);
         origin++;      
      }
   }
 }   

void Grayscale(char (*origin)[ColumnSize*4],int gray[rowSize+2][ColumnSize+2]){
   int i, j, max, min, v1, v2, v3;
   
   //padding for convolution
   for(i=0; i<ColumnSize+2; i++)
      gray[0][i]=0;
   
   for(i=0; i<ColumnSize+2; i++)
      gray[rowSize+1][i]=0;
   
   for(i=0; i<rowSize+2; i++)
      gray[i][0]=0;

   for(i=0; i<rowSize+2; i++)
      gray[i][ColumnSize+1]=0;
   
   //Save L(grayscale)
    for (i = 0; i < rowSize; i++)
   {
      for (j = 0; j < ColumnSize; j++)
      {    
            v1=origin[i][4 * j + 1];
        v2=origin[i][4 * j + 2];
        v3=origin[i][4*j+3];
            
        if(v1>v2) max=v1;
            else max=v2;
            if(max<v3) max=v3;
            
            if(v1<v2) min=v1;
        else min=v2;
            if(v3<min) min=v3;
            
        gray[i+1][j+1] = (max + min) / 2;
      }
   }
}
void convolution(int gray[rowSize+2][ColumnSize+2], int (*conv)[ColumnSize])    
{
  int i, j, k, l, res, sum;
   
   // w array is float type but we change int type for quick speed 
  int w[3][3]={
      {128,-143,51},
      {-143,0,-77},
      {51,-77,128}
   };
    
   //convolution
      for (i = 0; i<rowSize; i++) {
         for (j = 0; j<ColumnSize; j++) {
            sum = 0;
            for (k = 0; k<3; k++) {
               for (l = 0; l<3; l++) {
                  res = w[k][l] * gray[k + i][l + j];
                  sum += res;
               }
            }
            if (sum < 0) sum = 0; //check sum<0? (this way is more faster)
            conv[i][j] = sum; //because w is float type
         }
   }
}
void maxpooling(int (*conv)[ColumnSize], int (*result)[resColumnSize])
{
   int ii = 0, jj;
   int i, j, v1, v2, v3, v4, ab, cd;
   
   for (i = 0; i < rowSize; i = i + 2) {
      jj = 0;
      for (j = 0; j < ColumnSize; j = j + 2) {
            v1=conv[i][j];
        v2=conv[i][j + 1];
        v3=conv[i + 1][j];
        v4=conv[i + 1][j + 1];
        if (v1 > v2)  ab = v1;
        else ab = v2;
        if (v3 > v4)  cd = v3;
        else cd = v4;
        if (ab > cd) result[ii][jj]=ab/1024;
        else result[ii][jj]=cd/1024;
         jj++;
      }
      ii++;
   }
}