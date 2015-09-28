/*
Name:      Joshua Pinos
Professor: Albert Chan
Class:     CSC 471
Date:      September 13th, 2015
*/

#include <stdio.h>
#include "mpi.h"
int main (int argc, char **argv){
        int size;
        int id;
        MPI_Init (&argc, &argv);
        MPI_Comm_size (MPI_COMM_WORLD, &size);
        MPI_Comm_rank (MPI_COMM_WORLD, &id);
        /*Root Case*/        
        if(id == 0){
                printf ("Hello world from process ROOT of %d.\n", size);
        }
        else{
                /*Even Case*/
                if(id%2==0){
                        printf ("Hello world from process %d of %d.\n", id, size);
                }
                /*Odd Case*/
                else{
                        printf ("Welcome to the world from process %d of %d.\n", id, size);
                }        
        }
        MPI_Finalize ();
        return 0;
}
