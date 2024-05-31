%{
int nb_ligne=1, col=1;	
#include<stdio.h>
#include<stdlib.h>
#include<string.h>
#include"ts.h"
#include "QUAD.h"
#include "QUAD.c"
#include "optimisation.h"
#include "optimisation.c" 
#include "cod_obg.c"
#include "cod_obg.h"
int valuetype = 0;
int constant;
int i=0 ;
int typePartieGauche;
int j;
int sauvtype , fin_pos ,sauv_debut_do ,sauv_deb_for; 
int a=0;
int k=1;
float val_cst;
int else_pos;
int compatibilite = 0;
int compatibilite2 = 0;
 int nTemp=1;
 float valeur;
 char tempC[12]="";
char val[12]="";
char val1[20]="";
char val2[20]="";
char  * sauv_idf;
char * id;
 
%}
/**

int i=0 ,j,a=0 ,compatibilite = 0, k=1 , valuetype = 0 , nb_ligne=1 ,Col=1 , nTemp=1;
int sauvtype,fin_pos ,sauv_debut_while ,sauv_deb_for ,else_pos; 
char tempC[12]="" , val[12]="";
char  *sauv_idf ,  *id;

	 
void insert_liste_idf(int code_type){
      while(sauv_var != NULL)
        {  
            id= depiler(&sauv_var);
            inserer(strdup(id),code_type, 0 , 2);
        }
}
%}


**/

%union {char* str;
        int  integer;
        float f; 
        struct {
                char* res;
                 int type;
                float  val;
                }EXP;	   	
}

%token mc_varg  mc_instruction mc_string mc_const mc_int mc_flt  err  mc_declaration
%token fois plus moins slash par_o par_f mc_and mc_or mc_not mc_sup mc_inf mc_supe mc_infe mc_egale mc_dif mc_aff
%token sep_var dept cro_o cro_f vrgl aco_o aco_f pointvrgl point
%token mc_read mc_write mc_if mc_else mc_for mc_while <str> idf <integer> entier <f> reel "." 
 //ordre de priorité   

%left mc_or mc_and
%left mc_not mc_sup  mc_inf  mc_supe  mc_infe     mc_egale  mc_dif
%left plus  moins
%left fois   slash

%type <EXP> expr  expr_ar  condition bornesup debut_for for 
%start S   

%%
S:   mc_varg cro_o declaration cro_f mc_declaration cro_o declaration cro_f mc_instruction cro_o instruction cro_f {printf("\nprogramme syntaxiquement correct\n\n");
                                                  YYACCEPT;
					                             }
;


//*****************************************les déclarations******************************************************//

declaration: var declaration
            |const declaration
			|array declaration
            |			
;

//******************************************************************************************************************************//

/*
liste_idf:idf vrgl liste_idf {if(doubleDeclaration(strdup($1)) == 1){
		                         printf("\t\n\nerror semantique double declaration de l'id %s, a la ligne %d et la colonne %d\n",$1,nb_ligne,col);
	                            }else{
		                         //printf(" la valuer de double est%d\n",doubleDeclaration(strdup($3)));
				                 inserer(strdup($1),3,0,0);
								    }
	                          }
          |idf {if(doubleDeclaration(strdup($1)) == 1){
		            printf("\t\n\nerror semantique double declaration de l'id %s, a la ligne %d et la colonne %d\n",$1,nb_ligne,col);
	              }else{
		                //printf(" la valuer de double est%d\n",doubleDeclaration(strdup($3)));
				        inserer(strdup($1),3,0,0);}
	           }
;*/
var: type_var liste_idf_var pointvrgl
;


liste_idf_var: idf vrgl liste_idf_var {if(doubleDeclaration(strdup($1)) == 1){
		                         printf("\t\n\nerror semantique double declaration de l'id %s, a la ligne %d et la colonne %d\n",$1,nb_ligne,col);
	                            }else{
		                         //printf(" la valuer de double est%d\n",doubleDeclaration(strdup($3)));
				                 inserer(strdup($1),sauvtype,0,0);
								    }
	                          }
          |idf {if(doubleDeclaration(strdup($1)) == 1){
		            printf("\t\n\nerror semantique double declaration de l'id %s, a la ligne %d et la colonne %d\n",$1,nb_ligne,col);
	              }else{
		                //printf(" la valuer de double est%d\n",doubleDeclaration(strdup($3)));
				        inserer(strdup($1),sauvtype,0,0);}
	           }
;
type_var: mc_int {sauvtype = 1;  }| mc_flt {sauvtype = 2; }
;
//******************************************************************************************************************************//
const: mc_const type_const liste_idf_const pointvrgl
      |mc_const idf mc_aff valeur pointvrgl {  
										       /*printf("%f\n",val_cst);
										       if(val_cst< -32768.0 || constant>32767.0){
											      printf("erreur semantique: a la ligne %d l'entier %f est plus long\n",nb_ligne,val_cst);
											   }*/
		                                       if(doubleDeclaration(strdup($2)) == 1){
		                                               printf("\t\n\nerror semantique double declaration de l'id %s, a la ligne %d et la colonne %d\n",$2,nb_ligne,col);
	                                            }else{
														  //printf(" la valuer de double est%d\n",doubleDeclaration(strdup($2)));
														  //printf("%f",sauvtype);
														  inserer_cst(strdup($2),sauvtype,0,1,val_cst);
														  val_cst = 0;
														  //printf("%d \t",CONST_VALEUR($2));
														  }
	                                        }
;

valeur: entier {sauvtype = 1;val_cst = $1;} | reel {sauvtype = 2;val_cst = $1;}
;

liste_idf_const: idf vrgl liste_idf_const {if(doubleDeclaration(strdup($1)) == 1){
		                                      printf("\t\n\nerror semantique double declaration de l'id %s, a la ligne %d et la colonne %d\n",$1,nb_ligne,col);
	                                       }else{
		                                    //printf(" la valuer de double est%d\n",doubleDeclaration(strdup($3)));
				                             inserer(strdup($1),sauvtype,0,1);//printf("%d \t",CONST_VALEUR($1));
											 }
	                                      }
                 |idf {if(doubleDeclaration(strdup($1)) == 1){
		            printf("\t\n\nerror semantique double declaration de l'id %s, a la ligne %d et la colonne %d\n",$1,nb_ligne,col);
	              }else{
		                //printf(" la valuer de double est%d\n",doubleDeclaration(strdup($3)));
				        inserer(strdup($1),sauvtype,0,1);//printf("%d \t",CONST_VALEUR($1));
						}
	           }
type_const : mc_int {sauvtype = 1; }| mc_flt {sauvtype = 2; }
;
//******************************************************************************************************************************//
array : type_array dept liste_idf_tab pointvrgl
;

liste_idf_tab :idf aco_o entier aco_f vrgl liste_idf_tab{if(doubleDeclaration(strdup($1)) == 1){
		                                                    printf("\t\n\nerror semantique double declaration de l'id %s, a la ligne %d et la colonne %d\n",$1,nb_ligne,col);
	                                                      }else{
		                                                    //printf(" la valuer de double est%d\n",doubleDeclaration(strdup($3)));
				                                           inserer(strdup($1),sauvtype,$3,0);}
	                                                    }
              |idf aco_o entier aco_f {if(doubleDeclaration(strdup($1)) == 1){
		                                        printf("\t\n\nerror semantique double declaration de l'id %s, a la ligne %d et la colonne %d\n",$1,nb_ligne,col);
	                                        }else{
												 //printf(" la valuer de double est%d\n",doubleDeclaration(strdup($1)));
											     inserer(strdup($1),sauvtype,$3,0);}
	                                  }
;

type_array: mc_int {sauvtype = 1;} | mc_flt {sauvtype = 2;}
;
//*****************************************les instructions******************************************************//

instruction: int_if instruction
            |affectation instruction
			|for instruction
			|while instruction
			|Instread instruction
			|Instwrite instruction
			|
;

//********************** if ********************************//
int_if: A  mc_else cro_o instruction cro_f { fin_pos = depiler_qc(&pile1); 
                                             q[fin_pos].op1= ToSTR(indq); 
											 //printf("programme just\n");
										   }
;
A: B cro_o instruction cro_f {else_pos = depiler_qc(&pile1); 
                              q[else_pos].op1= ToSTR(indq+1); 
							  empiler_qc(&pile1, indq); 
							  quad("BR","","","");
							  }
;
B:mc_if par_o condition par_f { empiler_qc(&pile1, indq); 
                                quad("BZ","",strdup($3.res),""); 
							  }
;
//********************** affectation ***********************//

affectation: partie_gauche mc_aff expr pointvrgl { //printf("%d",compatibilite);
                                                   if(a != compatibilite){printf("\n\nerror semantique a la ligne %d ,et a la colonne %d,-----type incompatible-------",nb_ligne,col)  ;}
                                                   compatibilite=0;  
												   quad (":=",$3.res,"",sauv_idf);
												   //printf("%s",sauv_idf);
												   //printf("%f",$3.val);
												   if(dec(sauv_idf) == 1){
													   //printf("%s",sauv_idf);
													   //printf("%d",dec(sauv_idf));
													   inserer(strdup(sauv_idf),a,0,0);
													   inser_val(sauv_idf,$3.val);
												   }
                                                   else{
													   //printf("%d",dec(sauv_idf));
													   inser_val(sauv_idf,$3.val);}
             
                                                 }
;
partie_gauche : idf {if(dec($1) == 1){
		                printf("\t\n \n error semantique idf  %s est non declare, a la ligne %d et la colonne %d\n \n",$1,nb_ligne,col);
		               }
					   if(CONST_VALEUR($1) == 1) {
							    printf("\n\n erreur semantique : a la ligne %d,la constant %s a deja une valeur\n", nb_ligne,$1);
					   }else{
					   
					   a = returntype($1);
                       //printf("%d",a);					   
					   sauv_idf=strdup($1);
					   }
	                }
               |idf aco_o  entier  aco_f {if(dec($1) == 1){
		                                   printf("\t\n \n error semantique idf  %s est non declare, a la ligne %d et la colonne %d\n \n",$1,nb_ligne,col);
		                                  }
										  
										  a = returntype($1); 
										  
										  if(veriftailletab($1,$3) == 1){
							                  printf("\n\n error semantique a la ligne %d ,et a la colonne %d,-----taille  du tableau  depasse la capacite-------\n\n",nb_ligne,col);
							              } 
										  sprintf(sauv_idf,"%s[%d] ",$1,$3);
										  //sauv_idf=strdup($1);
	                                     }
			   |idf aco_o  idf  aco_f {if(dec($1) == 1){
		                                   printf("\t\n \n error semantique idf  %s est non declare, a la ligne %d et la colonne %d\n \n",$1,nb_ligne,col);
		                                  }
										  
										  if(dec($3) == 1){
		                                   printf("\t\n \n error semantique idf  %s est non declare, a la ligne %d et la colonne %d\n \n",$3,nb_ligne,col);
		                                  }
										  
										  a = returntype($1); 
										  
										  if(veriftailletab($1,VAL_IDF($3)) == 1){
							                  printf("\n\n error semantique a la ligne %d ,et a la colonne %d,-----taille  du tableau  depasse la capacite-------\n\n",nb_ligne,col);
							              }
										  //printf("%f\n",VAL_IDF($3));
										  //sprintf(sauv_idf,"%s[%f]",$1,VAL_IDF($3));
										  sprintf(sauv_idf, "%s[%s]",$1,$3);
										  //printf("%s\n",sauv_idf);
										  //sauv_idf=strdup($1);
	                                     }
			   |idf point  idf  {        if(dec($1) == 1){
		                                   printf("\t\n \n error semantique idf  %s est non declare, a la ligne %d et la colonne %d\n \n",$1,nb_ligne,col);
		                                  }
										  
										  if(dec($3) == 1){
		                                   printf("\t\n \n error semantique idf  %s est non declare, a la ligne %d et la colonne %d\n \n",$3,nb_ligne,col);
		                                  }
										  
										  a = returntype($3); 
										  
										  //printf("%f\n",VAL_IDF($3));
										  //sprintf(sauv_idf,"%s[%f]",$1,VAL_IDF($3));
										  sprintf(sauv_idf, "%s.%s",$1,$3);
										  //printf("%s\n",sauv_idf);
										  //sauv_idf=strdup($1);
	                                     }
; 
//********************** for *******************************//

for:debut_for instruction cro_f { 
                                  sauv_idf = depiler(&sauv_var); 
                                  quad("+",strdup(sauv_idf),$$.res,strdup(sauv_idf)); 
                                  sauv_deb_for = depiler_qc(&pileFOR); 
								  quad("BR",ToSTR(sauv_deb_for),"",""); 
								  q[sauv_deb_for].op1= ToSTR(indq);								  
								}
;

debut_for: mc_for par_o idf dept expr dept bornesup  dept expr par_f cro_o {    if(dec($3) == 1){
		                                                                         printf("\t\n \n error semantique idf  %s est non declare, a la ligne %d et la colonne %d\n \n",$3,nb_ligne,col);
		                                                                         }
																				 a = returntype($3);
																				 //printf("%d------>%d\t",a,sauvtype);
																				 //printf("%d\t",returntype($3));
																				 //printf("%d------>%d\t",a,compatibilite2);
																				 if(a != sauvtype){printf("\n\nerror semantique a la ligne %d ,et a la colonne %d,-----type incompatible-------",nb_ligne,col)  ;}
																				 if(a != compatibilite2){printf("\n\nerror semantique a la ligne %d ,et a la colonne %d,-----type incompatible-------",nb_ligne,col)  ;}
                                                                                 compatibilite=0;
																				 //printf("%f\n",$7);
																				 quad(":=",$5.res,"",$3); 
																				 empiler_qc(&pileFOR,indq); 
																				 quad("BG","",$3,$9.res);
                                                                                 $$.res = strdup($7.res);																				 
																				 empiler_Str(&sauv_var, $3);
	                                                                           } 
;
bornesup : entier {$$.res = ToSTR($1);int x = $1;/*printf("%d\n",$1);*/}
          |idf {
		         $$.res = strdup($1);
				 $$.val = VAL_IDF($1);
			     if(dec($1) == 1){
		            printf("\t\n \n error semantique idf  %s est non declare, a la ligne %d et la colonne %d\n \n",$1,nb_ligne,col);
		          }
				  sauvtype = returntype($1);
		       }
;
//********************** while *****************************//
while : m_while instruction cro_f { int sauv_fin_while = depiler_qc(&pile2);
                                    sauv_debut_do = depiler_qc(&pile2); 
                                    quad("BR",ToSTR(sauv_debut_do),"","");
                                    q[sauv_fin_while].op1 = ToSTR(indq);
								  }
;
m_while : deb_while par_o condition par_f cro_o {empiler_qc(&pile2,indq);
                                                quad("BZ","",$3.res,"");
												} 
deb_while: mc_while { empiler_qc(&pile2,indq);  }  
;



condition: par_o expr_ar mc_sup expr_ar par_f {
	                                          if(compatibilite != compatibilite2){
												  printf("\n\nerror semantique a la ligne %d ,et a la colonne %d,-----type incompatible-------",nb_ligne,col)  ;
											  }
											  printf("%f\t",$2);
											  //printf("%d",compatibilite);
											  //printf("%d",compatibilite2);
											  compatibilite=0;
											  compatibilite2=0;
	                                          sprintf(tempC, "T%d",nTemp);
                                              nTemp++;
											  $$.res=strdup(tempC);
											  tempC[0]='\0'; 
											  createQuadCompare (6,$2.res,$4.res,$$.res);
											 }
         |par_o expr_ar mc_inf expr_ar par_f {
	                                          if(compatibilite != compatibilite2){
												  printf("\n\nerror semantique a la ligne %d ,et a la colonne %d,-----type incompatible-------",nb_ligne,col)  ;
											  }
			                                  sprintf(tempC, "T%d",nTemp);
		                                      nTemp++;$$.res=strdup(tempC);
											  tempC[0]='\0'; 
											  createQuadCompare (5,$2.res,$4.res,$$.res);
											 }
		 |par_o expr_ar mc_supe expr_ar par_f {
	                                            if(compatibilite != compatibilite2){
												  printf("\n\nerror semantique a la ligne %d ,et a la colonne %d,-----type incompatible-------",nb_ligne,col)  ;
											    }
			                                   sprintf(tempC, "T%d",nTemp);
		                                       nTemp++;$$.res=strdup(tempC);
											   tempC[0]='\0'; 
											   createQuadCompare (3,$2.res,$4.res,$$.res);
											  }
											  
		 |par_o expr_ar mc_infe expr_ar par_f {
	                                          if(compatibilite != compatibilite2){
												  printf("\n\nerror semantique a la ligne %d ,et a la colonne %d,-----type incompatible-------",nb_ligne,col)  ;
											  }
											  sprintf(tempC, "T%d",nTemp);
		                                       nTemp++;$$.res=strdup(tempC);
											   tempC[0]='\0'; 
											   createQuadCompare (4,$2.res,$4.res,$$.res);
											  }
											  
		 |par_o expr_ar mc_egale expr_ar par_f  {
	                                             if(compatibilite != compatibilite2){
												  printf("\n\nerror semantique a la ligne %d ,et a la colonne %d,-----type incompatible-------",nb_ligne,col)  ;
											     }
											     sprintf(tempC, "T%d",nTemp);
		                                         nTemp++;$$.res=strdup(tempC);
												 tempC[0]='\0'; 
												 //printf("%s\t",$2.res);
												 //printf("%s\t",$1);
												 //printf("%s\t",$4.res);
												 createQuadCompare (1,$2.res,$4.res,$$.res);
												}
		 |par_o expr_ar mc_dif expr_ar par_f    {
	                                              if(compatibilite != compatibilite2){
												     printf("\n\nerror semantique a la ligne %d ,et a la colonne %d,-----type incompatible-------",nb_ligne,col)  ;
											      }
											     sprintf(tempC, "T%d",nTemp);
		                                         nTemp++;$$.res=strdup(tempC);
												 tempC[0]='\0'; 
												 createQuadCompare (2,$2.res,$4.res,$$.res);
												 }
												 
		 |par_o condition mc_and condition par_f {
	                                                 if(compatibilite != compatibilite2){
												      printf("\n\nerror semantique a la ligne %d ,et a la colonne %d,-----type incompatible-------",nb_ligne,col)  ;
											        }
												   sprintf(tempC, "T%d",nTemp);
		                                           nTemp++;$$.res=strdup(tempC);
												   tempC[0]='\0'; 
												   /*printf("%s\n",$2.res);
												   printf("%s\n",$3);
												   printf("%s\n",$4.res);*/
												   createQuadLogic (3,$2.res,$4.res,$$.res);
												  }
		
		 |par_o condition  mc_or condition par_f {
	                                               if(compatibilite != compatibilite2){
												     printf("\n\nerror semantique a la ligne %d ,et a la colonne %d,-----type incompatible-------",nb_ligne,col)  ;
											      }
												  sprintf(tempC, "T%d",nTemp);
		                                          nTemp++;$$.res=strdup(tempC);
												  tempC[0]='\0';
                                                  //printf("%s\t",$2.res);
                                                  //printf("%s\t",$4.res);												  
												  createQuadLogic (2,$2.res,$4.res,$$.res);
												 }
		 |expr_ar   
;
expr_ar: expr { $$.res = $1.res;
                //$$.val = $1.val; 
			  }
;
expr:expr  plus expr {             sprintf(tempC, "T%d",nTemp);
                                   nTemp++;
								   $$.res=strdup(tempC);
								   tempC[0]='\0'; 
								   //printf("%s",tempC);
								   $$.val = $1.val + $3.val;
								   /*printf("%f ",$1.val);
								   printf("%f ",$3.val);
								   printf("%f ",$$.val);*/
								   compatibilite = 2;								   
                                   //printf("%d ",compatibilite);				
								   quad ("+",$1.res,$3.res,$$.res);
				     }
								   
								   
    |expr  moins expr  {            sprintf(tempC, "T%d",nTemp);
	                                nTemp++;
									$$.res=strdup(tempC);
									tempC[0]='\0'; 
									//printf("%s",tempC);
									$$.val = $1.val - $3.val;
                                    /*printf("%f ",$1.val);
									printf("%f ",$3.val);
									printf("%f ",$$.val);*/
									compatibilite = 2;	
                                    //printf("%d ",compatibilite);									   
									quad ("-",$1.res,$3.res,$$.res);
					   }
								   
								   
    |expr  fois expr   {            sprintf(tempC, "T%d",nTemp);
	                                nTemp++;$$.res=strdup(tempC);
									tempC[0]='\0';
									//printf("%s",tempC);
									$$.val = $1.val * $3.val;
									/*printf("%f ",$1.val);
									printf("%f ",$3.val);*/
									//printf("%f ",$$.val);
									compatibilite = 2;
									//printf("%d ",compatibilite);											
									quad ("*",$1.res,$3.res,$$.res); 
					   }
	|expr  slash expr  {            sprintf(tempC, "T%d",nTemp);
	                                nTemp++;$$.res=strdup(tempC);
									tempC[0]='\0';
                                    //printf("%s",tempC);	
                                    $$.val = $1.val / $3.val;
                                    /*printf("%f ",$1.val);
									printf("%f ",$3.val);
									printf("%f ",$$.val);*/
									compatibilite = 2;	
                                    //printf("%d ",compatibilite);									
									quad ("/",$1.res,$3.res,$$.res);
									//printf("%s",$3.res);
									  if ($3.val==0){  printf( "\n\n erreur semantique ---- division sur 0----- a la ligne %d ,et a la colonne %d\n",nb_ligne,col);}
                                   }
	|idf {if(dec($1) == 1){
		    printf("\t\n\n error semantique idf  %s est non declare, a la ligne %d et la colonne %d\n",$1,nb_ligne,col);
		   }
		   
		   if(compatibilite == 0) {compatibilite = returntype(strdup($1)) ; 
		                           compatibilite2 = returntype(strdup($1)); 
                       		      } 
                                         /*else { 
                                                 if(compatibilite != returntype(strdup($1))) { printf("error semantique a la ligne %d ,et a la colonne %d,-----type incompatible-------",nb_ligne,col) ;}
                                              }*/ 
		   
		   $$.res=strdup($1);
		   //printf("%f\n",VAL_IDF($1));
		   $$.val=VAL_IDF($1);
		   //printf("(%s)-----%f\n",$1,$$.val);
	     }
	|idf aco_o  entier  aco_f { if(dec($1) == 1){
		                         printf("\t\n \n error semantique idf  %s est non declare, a la ligne %d et la colonne %d\n \n",$1,nb_ligne,col);
		                        }
								
								 if(compatibilite == 0) {compatibilite = returntype(strdup($1)) ;
								                         compatibilite2 = returntype(strdup($1));                              
										                } 
                                         /*else { 
                                                 if(compatibilite != returntype(strdup($1))) { printf("error semantique a la ligne %d ,et a la colonne %d,-----type incompatible-------",nb_ligne,col) ;}
                                              }*/
	                          
							    if(veriftailletab($1,$3) == 1){
							       printf("error semantique a la ligne %d ,et a la colonne %d,-----taille  du tableau  depasse la capacite-------",nb_ligne,col);
							      }     
							    sprintf(val1, "%s[%d]",$1,$3); 
								$$.val = VAL_IDF(val1);
								//val = $$.val;
								//printf("ççççç  %f  çççççç",val);
								sprintf(val2, "%f",VAL_IDF(val1));
							    $$.res=strdup(val1);
							  }
	|idf aco_o  idf  aco_f {if(dec($1) == 1){
		                         printf("\t\n \n error semantique idf  %s est non declare, a la ligne %d et la colonne %d\n \n",$1,nb_ligne,col);
		                        }
							 if(dec($3) == 1){
		                         printf("\t\n \n error semantique idf  %s est non declare, a la ligne %d et la colonne %d\n \n",$3,nb_ligne,col);
		                        }
								
								 if(compatibilite == 0) {compatibilite = returntype(strdup($1)) ;
								                         compatibilite2 = returntype(strdup($1));                              
										                } 
                                         /*else { 
                                                 if(compatibilite != returntype(strdup($1))) { printf("error semantique a la ligne %d ,et a la colonne %d,-----type incompatible-------",nb_ligne,col) ;}
                                              }*/
	                          
							    if(veriftailletab($1,VAL_IDF($3)) == 1){
							       printf("\n\n error semantique a la ligne %d ,et a la colonne %d,-----taille  du tableau  depasse la capacite-------",nb_ligne,col);
							      }
                                //char*	val1;							  
							    sprintf(val1, "%s[%f]",$1,VAL_IDF($3));
								$$.val = VAL_IDF(val1);
                                //printf("ççççç  %f  çççççç",$$.val);
                                sprintf(val2, "%s[%s]",$1,$3);								
							    $$.res=strdup(val2);
								//printf("ççççç  %s çççççç",$$.res);
	                        }
	 |idf point idf {      if(dec($1) == 1){
		                         printf("\t\n \n error semantique idf  %s est non declare, a la ligne %d et la colonne %d\n \n",$1,nb_ligne,col);
		                        }
							 if(dec($3) == 1){
		                         printf("\t\n \n error semantique idf  %s est non declare, a la ligne %d et la colonne %d\n \n",$3,nb_ligne,col);
		                        }
								
								 if(compatibilite == 0) {compatibilite = returntype(strdup($1)) ;
								                         compatibilite2 = returntype(strdup($1));                              
										                } 
                                         /*else { 
                                                 if(compatibilite != returntype(strdup($1))) { printf("error semantique a la ligne %d ,et a la colonne %d,-----type incompatible-------",nb_ligne,col) ;}
                                              }*/
	                          
                                //char*	val1;							  
							    sprintf(val1, "%s.%s",$1,VAL_IDF($3));
								$$.val = VAL_IDF(val1);
                                printf("ççççç  %f  çççççç",$$.val);
                                sprintf(val2, "%s.%s",$1,$3);								
							    $$.res=strdup(val2);
								//printf("ççççç  %s çççççç",$$.res);
	                }
			
	|entier {    
                      if(compatibilite == 0) {compatibilite = 1;}
                         /*else  { if (compatibilite != 1 ){
            						    printf("error semantique a la ligne %d ,et a la colonne %d,-----type incompatible-------",nb_ligne,col)  ;
									}
                               } */
                      if(compatibilite2 == 0) {compatibilite2 = 1;}							   							   
                      sprintf(val, "%d",$1); 
					  $$.res=strdup(val); 
					  $$.val=$1;
                      //printf("%s ",$$.res);					  
			}
			
			
	|reel {  if(compatibilite == 0) {compatibilite = 2;} 
            
                        /*else  { if (compatibilite != 2 )
                                                   { printf("error semantique a la ligne %d ,et a la colonne %d,-----type incompatible-------",nb_ligne,col)  ;}
                              }*/
            if(compatibilite2 == 0) {compatibilite2 = 2;}		
             sprintf(val, "%f",$1);			 
			 $$.res=strdup(val);     
			 $$.val=$1;  
          }
	 
	 | par_o expr par_f  { $$.res=$2.res;   $$.val=$2.val;}
;

Instread: mc_read par_o idf par_f pointvrgl {if(dec($3) == 1){
		                printf("\t\n \n error semantique idf  %s est non declare, a la ligne %d et la colonne %d\n \n",$3,nb_ligne,col);
								}}
    ; /* Code pour traiter l'instruction READ */ 


Instwrite: mc_write par_o Listparamwrite par_f pointvrgl ; /* Code pour traiter l'instruction WRITE */ 
Listparamwrite: mc_string vrgl idf vrgl mc_string | mc_string; 

%%

yyerror(char*msg)           
 {
 printf(" erreur syntaxique a la ligne %d et a la colonne %d \n", nb_ligne, col);
  exit ;
 }
main()
{
 init();

yyparse();
printf("\n \n");

printf("\n-----------------------------------   les quadruplets   --------------------------------\n");
afficherQuad();

printf("\n\n\n-------------------------------------Partie optimisation--------------------------------\n\n\n");



printf("\n            ****************************************************************************     \n");




afficherQuad();
printf("\n            ****************************************************************************     \n");



printf("\n                         -------------Simplification algébrique------------     \n");

simplifierAlg();
afficherQuad();


printf("\n            ****************************************************************************     \n");



printf("\n                         -------------  Les IDSs non utilisées ------------     \n");

checkVarUse();
afficherQuad();
printf("\n            ****************************************************************************     \n");



printf("\n                         -------------propagation de copie------------     \n");

Propagation_de_copie( );
afficherQuad();
printf("\n            ****************************************************************************     \n");




printf("\n                         -------------propagation Arithemetique------------     \n");
propArth();
afficherQuad();

printf("\n            ****************************************************************************     \n");


printf("\n                         -------------elimination des tempons repetees------------     \n");
eliminer();
afficherQuad();

printf("\n   ------------------------------------>  optimisation final  <-------------------------------------     \n");

optimisation();

printf("\n\t \t \t ********  objectif atteint ********\n\n\n");
printf("\t\t\t\t\t ------------------------------------------------\n");
afficherQuadFinal();
printf("\t\t\t\t\t ------------------------------------------------\n");

printf("\n\n\n-------------------------------------Partie code machine--------------------------------\n\n\n");
assembler();

printf("\n \n");
//  table des mots clés et séparateurs
afficher();    
printf("\n \n");

// table  IDF 
printHachTable();
printf("\n\n");

    
}
yywrape(){}


 