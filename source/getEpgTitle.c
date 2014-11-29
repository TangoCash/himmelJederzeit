/*
 * getEpgTitle.c
 *
 *  Created on: 18.07.2013
 *      Author: erdal
 */

#include <stdio.h>
#include <fcntl.h>
#include <string.h>
#include <malloc.h>
#define TAG1 "<epgtitle>"
#define TAG2 "</epgtitle>"

char *FindNext(char *sp, char *ep, char *SearchStr, int MaxLen)
{
	char c = *SearchStr;
	ep -= MaxLen;
	while (sp < ep) {
		if (*sp == c) {
			if (memcmp(sp, SearchStr, MaxLen) == 0)
				return (sp);
		}
		sp++;
	}
	return (0);
}

void ParseString(const char *ip, char *op)
{
	while (*ip) {
		if (*ip == '\\') {
			ip++;
			if (*ip == '\\') {
				*op++ = *ip;
				ip++;
			}
			if (*ip == 'n') {
				*op++ = 10;
				ip++;
			}
			if (*ip == 'r') {
				*op++ = 13;
				ip++;
			}
		}
		else
			*op++ = *ip++;
	}
	*op = 0;
}

void trim(char str[] )
{
	if (!str)
		return;

	char *ptr = str;
	int len = strlen(ptr);

	while (len - 1 > 0 && isspace(ptr[len - 1]))
		ptr[--len] = 0;

	while (*ptr && isspace(*ptr))
		++ptr, --len;

	memmove(str, ptr, len + 1);
}

int main(int argc, char **argv)
{
	int i = 1;
	int j = 0;

	int tlen = strlen(TAG1);
	int tlen2 = strlen(TAG2);
	for (i = 1; i < argc; i++) {
		FILE *fp = fopen(argv[i], "r");
		if (fp == NULL) {
			printf("cannot open file %s\n", argv[i]);
			continue;
		}
		char st[1000];
		while (fgets(st, sizeof(st), fp) != NULL) {
			j++;
			int len = strlen(st);
			char *p = FindNext(st, st + len, TAG1, tlen);
			if (p != NULL) {
				memmove(p, p + tlen, (st + len) - (p + tlen) + 1);
				char *p = FindNext(st, st + len, TAG2, tlen2);
				if (p != NULL) {
					*p = 0;
				}

				trim(&st);

				trim(st);
				printf("%s\n", st);
			}
		}
		fclose(fp);
	}
	return 0;
}

