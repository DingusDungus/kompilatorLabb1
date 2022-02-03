#Så vi måste ta bort alla onödiga saker som `()` och `{}` eftersom trädet hierarchy med nordernas barn osv redan ger den informationen.

#Sen ska vi inte heller ha tex `[]` utan vi kan ersätta det med en "ArrayAccess" node som har det expression som finns inuti `[]` som sitt child

#För typen "int[]" vid en declaration så gör vi bara en node som heter "intergerArray"

#Sen måste vi också fixa Expression precedence så att multiplikation sker före addition osv. Han har tydligen länkat i uppgiften ett dokument som förklarar hur man gör det i bison. För nu om vi har tex `Expression1 + Expression2` men Expression1 är `10*2` och Expression2 är `10+2` så egentligen `10*2+10+2` så borde Expression1 göras först innan något annat eftersom det är multiplikation. Men som vi har det nu utan någonting för att hantera precedence kommer den alltid göra det från höger oavsett. Så Expression2 körs alltid först.

#Behöver inte heller ha semicolon ;
