
s = getsym (symbuf);
if (s == 0)
s = putsym (symbuf, VAR);
yylval.tptr = s;
return s->type;