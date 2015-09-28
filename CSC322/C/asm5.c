/*
Author:     Joshua Pinos
Professor:  Albert Chan
Assignment: 5
Date:       April 19th, 2015
*/
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
/*
Data structure to hold information about cities and time.
*/
struct p2p
{
    int city1;
    int city2;
    float time;
};
/*
Function to calculate average travel time between cities and records data to file.
*/
void routeCalculationWithOutput(FILE *output,struct p2p cities[],int scount,int n)
{
    int i = 0;
    while(i<n)
    {
        int j = 0;
        while(j<n)
        {
            int c = 0;
            double sum = 0.0;
            int hits=0;
            while(c<scount)
            {
                if(cities[c].city1==(i+1) && cities[c].city2==(j+1))
                {  
                    sum = sum + cities[c].time;
                    hits++;
                }
                c++;
            }
            if(i==j)
            {
            }
            else
            {
                if(hits==0)
                {
                    fprintf(output,"From city %d to city %d: --\n",i+1,j+1);
                }
                else
                {
                    double result = sum/hits;
                    fprintf(output,"From city %d to city %d: %5.2lf (%d)\n",i+1,j+1,result, hits);
                }
            }
            j++;
        }
        fprintf(output,"\n");
        i++;
    }
}
/*
Function to calculate average travel time between cities and output results to console.
*/
void routeCalculationWithoutOutput(struct p2p cities[],int scount, int n)
{
    int i = 0;
    while(i<n)
    {
        int j = 0;
        while(j<n)
        {
            int c = 0;
            double sum = 0.0;
            int hits=0;
            while(c<scount)
            {
                if(cities[c].city1==(i+1) && cities[c].city2==(j+1))
                {  
                    sum = sum + cities[c].time;
                    hits++;
                }
                c++;
            }
            if(i==j)
            {
            }
            else
            {
                if(hits==0)
                {
                    printf("From city %d to city %d: --\n",i+1,j+1);
                }
                else
                {
                    double result = sum/hits;
                    printf("From city %d to city %d: %5.2lf (%d)\n",i+1,j+1,result,hits);
                }
            }
            j++;
        }
        printf("\n");
        i++;
    }
}
/*
Handles processsing of cites froom input file and records status to  output file. 
*/
void transactionWithOutput(FILE *input,FILE *output)
{
    int n;
    int scount=0;
    fscanf(input,"%d",&n);
    int m = n;
    struct p2p *cities=malloc(m*sizeof(struct p2p));
    int a=0;
    int b=0;
    double c=0.0;
    while(fscanf(input,"%d %d %lf",&a,&b,&c)==3)
    {
        if(a<=n)
        {
            if(b<=n)
            {
                if(c>0)
                {
                    if(a!=b)
                    {
                        if(scount==m)
                        {
                            m=m*m;
                            cities=realloc(cities,m*sizeof(struct p2p));
                            cities[scount].city1 = a;
                            cities[scount].city2 = b;
                            cities[scount].time  = c;
                            fprintf(output," %d %d %5.2lf\n",a,b,c);
                            scount++;
                        }
                        else
                        {
                            cities[scount].city1 = a;
                            cities[scount].city2 = b;
                            cities[scount].time  = c;
                            fprintf(output," %d %d %5.2lf\n",a,b,c);
                            scount++;
                        }
                    }
                    else
                    {
                    fprintf(output," %d %d %5.2lf Error: Duplicated source and destination.\n",a,b,c);
                    }
                }
                else
                {
                fprintf(output," %d %d %5.2lf Error: Invalid time.\n",a,b,c);
                }
            }
            else
            {
            fprintf(output," %d %d %5.2lf Error: Invalid destination city.\n",a,b,c);
            }
        }
        else
        {
        fprintf(output," %d %d %5.2lf Error: Invalid source city.\n",a,b,c);
        }    
    }
    fprintf(output,"\nThe number of valid records: %d.\n\n",scount);
    routeCalculationWithOutput(output,cities,scount,n);
    free(cities);
}
/*
Function to hadle processing of cities from  input files and  echos status to console.
*/
void transactionWithoutOutput(FILE *input)
{
    int n;
    int scount=0;
    fscanf(input,"%d",&n);
    int m = n;
    struct p2p *cities=malloc(m*sizeof(struct p2p));
    int a=0;
    int b=0;
    double c=0.0;
    while(fscanf(input,"%d %d %lf",&a,&b,&c)==3)
    {
        if(a<=n && a>0)
        {
            if(b<=n && b>0)
            {
                if(c>0)
                {
                    if(a!=b)
                    {
                        if(scount==m)
                        {
                            m=m*m;
                            cities=realloc(cities,m*sizeof(struct p2p));
                            cities[scount].city1 = a;
                            cities[scount].city2 = b;
                            cities[scount].time  = c;
                            printf(" %d %d %5.2lf\n",a,b,c);
                            scount++;
                        }
                        else
                        {
                            cities[scount].city1 = a;
                            cities[scount].city2 = b;
                            cities[scount].time  = c;
                            printf(" %d %d %5.2lf\n",a,b,c);
                            scount++;
                        }
                    }
                    else
                    {
                    printf(" %d %d %5.2lf Error: Duplicated source and destination.\n",a,b,c);
                    }
                }
                else
                {
                printf(" %d %d %5.2lf Error: Invalid time.\n",a,b,c);
                }
            }
            else
            {
            printf(" %d %d %5.2lf Error: Invalid destination city.\n",a,b,c);
            }
        }
        else
        {
        printf(" %d %d %5.2lf Error: Invalid source city.\n",a,b,c);
        }    
    }
    printf("\nThe number of valid records: %d.\n\n",scount);
    routeCalculationWithoutOutput(cities,scount,n);
    free(cities);
}
/*
Main() function that handles processing of input and output files.
*/
int main(int argc, char *argv[])
{
    FILE *ifp = NULL;
    FILE *ofp = NULL;
    if(argc == 1 )
    {
        printf("Usage: csc322a5 <infile> [<outfile>]\n");
    }
    else{
        if(argc==2)
        {
            ifp=fopen(argv[1],"r");
            if(ifp == NULL)
            {
                printf("Error: Cannot open input file [%s].\n",argv[1]);
            }
            else
            {
                transactionWithoutOutput(ifp);
                fclose(ifp);
            }
        }
        else
        {
            ifp=fopen(argv[1],"r");
            ofp=fopen(argv[2],"r");
            if(ofp == NULL && ifp == NULL)
            {
                printf("Error: Cannot open input file [%s].\n",argv[1]);
                exit(0);
            }
            if(ifp == NULL)
            {
                printf("Error: Cannot open input file [%s].\n",argv[1]);
                exit(0);
            }
            if(ofp == NULL)
            {
                printf("Error: Cannot open output file [%s].\n",argv[2]);
                exit(0);
            }
            else
            {
                fclose(ofp);
                fopen(argv[2],"w");
                transactionWithOutput(ifp,ofp);
                fclose(ifp);
                fclose(ofp);
            }
        }
    }
    return 0;
}
