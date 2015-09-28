/*
 * Student:    Joshua Pinos
 * Professor:  Sambit Bhattacharya
 * Class:      CSC 431
 * Date:       September 23rd, 2015
 * Assignment: Edit the shellex.c file to process comma separated commands
 */

/* $begin shellmain */
#include "csapp.h"
#define MAXARGS   128
#define MAXCOMMANDS   30 /* Maximum number of commands that are able to be stored and ran per command line input. */
/* Function prototypes */
void eval(char *cmdline);
int parseline(char *buf, char **argv);
int builtin_command(char **argv);

int main() {
	char cmdline[MAXLINE]; /* Command line */
	while (1) {
		char *cmdArray[MAXCOMMANDS]; /* Array that holds all parsed commands. NOTE: This array could be dynamically allocated as well */
		int cmdCount = 0;
		/* Read */
		printf("> ");
		Fgets(cmdline, MAXLINE, stdin);
		if (feof(stdin))
			exit(0);
		int i = 0;/* Marks start of parsed command token */
		int j = 0;/* Marks end of parsed command token */
		int bool = 1; /* Boolean value to control exiting out of loop when end of command line input is reached */

		/* Loop that checks character by character for a comma or newline by incrementing the end counter.
		 * When the end counter reaches this condition, the command token between the start counter and end counter is copied to a dynamically allocated temporary buffer.
		 * This temporary buffer is saved to an array for later processing.
		 * Finally the start counter is moved to the character after the end counter and the cycle repeats again.
		 */
		while (bool == 1) {
			/* Condition that deals with a command line only having a newline character(i.e. no input) */
			if (cmdline[j] == '\n' && j == 0) {
				bool = 0;
			} else {
				/* Condition that extracts a command token when a comma is reached */
				if (cmdline[j] == ',') {
					char *tmp;
					tmp = (char *) malloc(1028);
					memcpy(tmp, cmdline + i, j - i);
					tmp[j - i] = '\n';
					cmdArray[cmdCount] = tmp;
					i = j + 1;
					j = j + 1;
					cmdCount = cmdCount + 1;
				} else {
					/* Condition that extracted a command token when a newline is reached */
					if (cmdline[j] == '\n') {
						char *tmp;
						tmp = (char *) malloc(1028);
						memcpy(tmp, cmdline + i, j - i + 1);
						cmdArray[cmdCount] = tmp;
						cmdCount = cmdCount + 1;
						bool = 0;
					}
					/* Increment the end counter */
					else {
						j = j + 1;
					}
				}
			}
		}
		int e = 0; /* Counter responsible for iterating through the command array */
		/* Loop to run each command in the command array. */
		while (e < cmdCount) {
			eval(cmdArray[e]);
			free(cmdArray[e]);
			e++;
		}
	}
}
/* $end shellmain */

/* $begin eval */
/* eval - Evaluate a command line */
void eval(char *cmdline) {
	char *argv[MAXARGS]; /* Argument list execve() */
	char buf[MAXLINE]; /* Holds modified command line */
	int bg; /* Should the job run in bg or fg? */
	pid_t pid; /* Process id */

	strcpy(buf, cmdline);
	bg = parseline(buf, argv);
	if (argv[0] == NULL)
		return; /* Ignore empty lines */

	if (!builtin_command(argv)) {
		if ((pid = Fork()) == 0) { /* Child runs user job */
			if (execve(argv[0], argv, environ) < 0) {
				printf("%s: Command not found.\n", argv[0]);
				exit(0);
			}
		}

		/* Parent waits for foreground job to terminate */
		if (!bg) {
			int status;
			if (waitpid(pid, &status, 0) < 0)
				unix_error("waitfg: waitpid error");
		} else
			printf("%d %s", pid, cmdline);
	}
	return;
}

/* If first arg is a builtin command, run it and return true */
int builtin_command(char **argv) {
	if (!strcmp(argv[0], "quit")) /* quit command */
		exit(0);
	if (!strcmp(argv[0], "&")) /* Ignore singleton & */
		return 1;
	return 0; /* Not a builtin command */
}
/* $end eval */

/* $begin parseline */
/* parseline - Parse the command line and build the argv array */
int parseline(char *buf, char **argv) {
	char *delim; /* Points to first space delimiter */
	int argc; /* Number of args */
	int bg; /* Background job? */

	buf[strlen(buf) - 1] = ' '; /* Replace trailing '\n' with space */
	while (*buf && (*buf == ' ')) /* Ignore leading spaces */
		buf++;

	/* Build the argv list */
	argc = 0;
	while ((delim = strchr(buf, ' '))) {
		argv[argc++] = buf;
		*delim = '\0';
		buf = delim + 1;
		while (*buf && (*buf == ' ')) /* Ignore spaces */
			buf++;
	}
	argv[argc] = NULL;

	if (argc == 0) /* Ignore blank line */
		return 1;

	/* Should the job run in the background? */
	if ((bg = (*argv[argc - 1] == '&')) != 0)
		argv[--argc] = NULL;

	return bg;
}
/* $end parseline */
