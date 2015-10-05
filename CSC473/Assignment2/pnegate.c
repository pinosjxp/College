/*
Name:      Joshua Pinos
Professor: Albert Chan
Class:     CSC 473
Date:      October 4th, 2015
*/

#include <stdio.h>
#include "mpi.h"
#include "image.h"
#include "utils.h"

void process_data (image *photo)
{
    int i, n;
    n = photo->width * photo->height * 3;
    for (i = 0; i < n; i++)
    {
        photo->data [i] = negate (photo->data [i], photo->max_value);
    }
}

image *setup (int argc, char **argv)
{
    image *photo;
    if (argc < 3)
    {
        fprintf (stderr, "Usage: %s <infile> <outfile>\n\n", argv [0]);
        return NULL;
    }

    photo = read_image (argv [1]);
    if (photo == NULL)
    {
        fprintf (stderr, "Unable to read input file %s\n\n", argv [1]);
        return NULL;
    }
    return photo;
}

void cleanup (image *photo, char **argv)
{
    int rc = write_image (argv [2], photo);
    if (!rc)
    {
        fprintf (stderr, "Unable to write output file %s\n\n", argv [2]);
    }
    clear_image (photo);
}

int main (int argc, char **argv){
    /* Declaration of variables. */
    int size;
    int id;
    int lds;
    int maxvalue;
    double start_time, end_time;
    image *photo;
    /* Initialize processors. */
    MPI_Init (&argc, &argv);
    /* Gets total number of processors. */
    MPI_Comm_size (MPI_COMM_WORLD, &size);
    /* Gets "pid" of processor. */
    MPI_Comm_rank (MPI_COMM_WORLD, &id);
    /* Master process reads in photo and stores local data size/max color value. */
    if(id==0){
        photo = setup(argc, argv);
        lds=((photo->width * photo->height * 3)/size);
        maxvalue= photo->max_value;
    }
    /* Starts timer. */
    start_time = MPI_Wtime();
    MPI_Bcast (&maxvalue,1, MPI_INT, 0, MPI_COMM_WORLD);
    MPI_Bcast (&lds, 1, MPI_INT, 0, MPI_COMM_WORLD);
    char rdata[lds];
    MPI_Scatter(photo->data,lds,MPI_UNSIGNED_CHAR,rdata,lds,MPI_UNSIGNED_CHAR,0,MPI_COMM_WORLD);
    /* Processes negate local data sections from photo. */
    int i;
    for(i=0; i<lds;i++){
        rdata[i]=negate(rdata[i],maxvalue);
    }
    /* Retrive data from  */
    MPI_Gather (rdata,lds,MPI_UNSIGNED_CHAR,photo->data,lds,MPI_UNSIGNED_CHAR,0,MPI_COMM_WORLD);
    /* Ends timer. */
    end_time = MPI_Wtime();
    /* Master process saves photo data and prints elapsed time. */
    if(id == 0){
        cleanup (photo, argv);
        printf ("Parallel elapsed time - %.2lf s.\n", end_time - start_time);
    }
    /* Ends processes */
    MPI_Finalize();
    return 0;
}
