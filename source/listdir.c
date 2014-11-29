#include <stdlib.h>
#include <stdio.h>
#include <sys/types.h>
#include <string.h>
#include <errno.h>
/* "readdir" etc. are defined here. */
#include <dirent.h>
/* limits.h defines "PATH_MAX". */
#include <limits.h>

/* List the files in "dir_name". */

static void list_dir(const char *dir_name, FILE *fp)
{
	DIR *d;

	/* Open the directory specified by "dir_name". */

	d = opendir(dir_name);

	/* Check it was opened. */
	if (!d) {
		fprintf(stderr, "Cannot open directory '%s': %s\n", dir_name,
		        strerror(errno));
		exit(EXIT_FAILURE);
	}
	while (1) {
		struct dirent *entry;
		const char *d_name;

		/* "Readdir" gets subsequent entries from "d". */
		entry = readdir(d);
		if (!entry) {
			/* There are no more entries in this directory, so break
			 out of the while loop. */
			break;
		}

		d_name = entry->d_name;
		if (entry->d_type & DT_REG) {

			/*int i;
			 const char * end;
			 for ( i = strlen(d_name)-3;i < strlen(d_name);i++ )
			 end += d_name[i];*/
			const char *resultat = strstr(d_name, ".xml\0");

			if (resultat) {
				//printf("%s/%s\n", dir_name, d_name);
				char daten[2048] = "";
				strcat(daten, dir_name);
				strcat(daten, "/");
				strcat(daten, d_name);
				strcat(daten, "\n");
//				printf("daten: %s\n",daten);
				fwrite(daten, strlen(daten), 1, fp);

			}
			/* Print the name of the file and directory. */
		}
		/* See if "entry" is a subdirectory of "d". */

		if (entry->d_type & DT_DIR) {

			/* Check that the directory is not "d" or d's parent. */

			if (strcmp(d_name, "..") != 0 && strcmp(d_name, ".") != 0) {
				int path_length;
				char path[PATH_MAX];

				path_length = snprintf(path, PATH_MAX, "%s/%s", dir_name,
				                       d_name);
				//printf("%s\n", path);
				if (path_length >= PATH_MAX) {
					fprintf(stderr, "Path length has got too long.\n");
					exit(EXIT_FAILURE);
				}
				/* Recursively call "list_dir" with the new path. */
				list_dir(path, fp);
			}
		}
	}

	/* After going through all the entries, close the directory. */
	if (closedir(d)) {
		fprintf(stderr, "Could not close '%s': %s\n", dir_name,
		        strerror(errno));
		exit(EXIT_FAILURE);
	}
}

int main(int argc, char *argv[])
{
	const char *file_name;
	const char *dir;

	if (argc < 2) return 0;

	file_name = argv[1];
	FILE *fp;

	fp = fopen(file_name, "a+"); // read mode

	if (fp == NULL) {
		perror("Error while opening the file.\n");
		exit(EXIT_FAILURE);
	}
	else
		printf("Datei handle geöffnet %s\n", file_name);


	if (argc > 1) {
		dir = argv[2];
	}
	else {
		dir = "/hdd/movies/anytime";
	}
	list_dir(dir, fp);
	fclose(fp);
	return 0;
}
