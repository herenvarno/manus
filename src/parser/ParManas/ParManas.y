%{

#include <math.h>
#include "util/Common.hpp"
#include "ir/IrManas/IrManas.hpp"

#define YYDEBUG 1

using namespace vesyla::ir;

extern int yylineno;
extern int yylex(void);
static void yyerror(const char*);

int coord_x = 0;
int coord_y = 0;
int curr_seg = 0;

IrManas* ir_ptr;

%}

%start input

%union {
	char* text;
	char* symbol;
	
	int IntegerValue;
	int IrBaseTypeId;
	
	void* CoordType;
	void* CoordList;
	void* NumberList;
}

%token <text> VARIABLE
%token CODE_SEG
%token DATA_SEG
%token <IntegerValue> FULL_DISTR
%token <IntegerValue> EVEN_DISTR
%token NEWLINE
%token CELL
%token DPU
%token REFI1
%token REFI2
%token REFI3
%token DELAY
%token RACCU
%token LOOPHEADER
%token LOOPTAIL
%token SWB
%token BRANCH
%token JUMP
%token SRAMREAD
%token SRAMWRITE
%token ROUTE
%token HALT
%token <IntegerValue> INTEGER
%token ADD
%token SUB
%token MUL
%token DIV
%token POW
%token PAL
%token PAR
%token BRACKET_L
%token BRACKET_R
%token SHEVRON_L
%token SHEVRON_R
%token COMMA
%token LEXERROR
%token ZEROS
%token ONES


%type <IntegerValue> number
%type <CoordType> coordinate
%type <CoordList> coordinate_list
%type <NumberList> number_list
%type <CoordList> location
%type <NumberList> array
%type <IntegerValue> distribution

%left ADD SUB
%left MUL DIV
%right POW

%locations

%%

input:
	segments{
	}
	| parse_error{
	}
	;

segments:
	segment{
	}
	| segments segment{
	}
	;
	
segment:
	DATA_SEG NEWLINE variables{
	}
	| CODE_SEG NEWLINE instructions{
	}
	| NEWLINE{
	}
	;

instructions:
	{
	}
	|instruction{
	}
	|instructions instruction{
	}
	;
	
instruction:
	instr_cell{
	}
	|instr_dpu{
	}
	|instr_refi1{
	}
	|instr_refi2{
	}
	|instr_refi3{
	}
	|instr_delay{
	}
	|instr_raccu{
	}
	|instr_loopheader{
	}
	|instr_looptail{
	}
	|instr_swb{
	}
	|instr_branch{
	}
	|instr_jump{
	}
	|instr_sramread{
	}
	|instr_sramwrite{
	}
	|instr_route{
	}
	|instr_halt{
	}
	;

instr_cell:
	CELL coordinate NEWLINE{
		coord_x = (*(static_cast<vector<int>*>($2)))[0];
		coord_y = (*(static_cast<vector<int>*>($2)))[1];
		delete $2;
	}
	;

instr_dpu:
	DPU number number number number number number number number NEWLINE{
		if(!ir_ptr->create_instr_dpu(coord_x, coord_y, $2, $3, $4, $5, $6, $7, $8, $9)){
			yyerror("DPU Instruction error!");
		}
	}
	|DPU number COMMA number COMMA number COMMA number COMMA number COMMA number COMMA number COMMA number NEWLINE{
		if(!ir_ptr->create_instr_dpu(coord_x, coord_y, $2, $4, $6, $8, $10, $12, $14, $16)){
			yyerror("DPU Instruction error!");
		}
	}
	;

instr_refi1:
	REFI1 number number number number number number number number NEWLINE{
		if(!ir_ptr->create_instr_refi1(coord_x, coord_y, $2, $3, $4, $5, $6, $7, $8, $9)){
			yyerror("REFI1 Instruction error!");
		}
	}
	|REFI1 number COMMA number COMMA number COMMA number COMMA number COMMA number COMMA number COMMA number NEWLINE{
		if(!ir_ptr->create_instr_refi1(coord_x, coord_y, $2, $4, $6, $8, $10, $12, $14, $16)){
			yyerror("REFI1 Instruction error!");
		}
	}
	;

instr_refi2:
	REFI2 number number number number number number number number NEWLINE{
		if(!ir_ptr->create_instr_refi2(coord_x, coord_y, $2, $3, $4, $5, $6, $7, $8, $9)){
			yyerror("REFI2 Instruction error!");
		}
	}
	|REFI2 number COMMA number COMMA number COMMA number COMMA number COMMA number COMMA number COMMA number NEWLINE{
		if(!ir_ptr->create_instr_refi2(coord_x, coord_y, $2, $4, $6, $8, $10, $12, $14, $16)){
			yyerror("REFI2 Instruction error!");
		}
	}
	;

instr_refi3:
	REFI3 number number number number number number number number number number NEWLINE{
		if(!ir_ptr->create_instr_refi3(coord_x, coord_y, $2, $3, $4, $5, $6, $7, $8, $9, $10, $11)){
			yyerror("REFI3 Instruction error!");
		}
	}
	|REFI3 number COMMA number COMMA number COMMA number COMMA number COMMA number COMMA number COMMA number COMMA number COMMA number NEWLINE{
		if(!ir_ptr->create_instr_refi3(coord_x, coord_y, $2, $4, $6, $8, $10, $12, $14, $16, $18, $20)){
			yyerror("REFI3 Instruction error!");
		}
	}
	;

instr_delay:
	DELAY number number NEWLINE{
		if(!ir_ptr->create_instr_delay(coord_x, coord_y, $2, $3)){
			yyerror("DELAY Instruction error!");
		}
	}
	|DELAY number COMMA number NEWLINE{
		if(!ir_ptr->create_instr_delay(coord_x, coord_y, $2, $4)){
			yyerror("DELAY Instruction error!");
		}
	}
	;

instr_raccu:
	RACCU number number number number number number NEWLINE{
		if(!ir_ptr->create_instr_raccu(coord_x, coord_y, $2, $3, $4, $5, $6, $7)){
			yyerror("RACCU Instruction error!");
		}
	}
	|RACCU number COMMA number COMMA number COMMA number COMMA number COMMA number NEWLINE{
		if(!ir_ptr->create_instr_raccu(coord_x, coord_y, $2, $4, $6, $8, $10, $12)){
			yyerror("RACCU Instruction error!");
		}
	}
	;

instr_loopheader:
	LOOPHEADER number number number number NEWLINE{
		if(!ir_ptr->create_instr_loopheader(coord_x, coord_y, $2, $3, $4, $5)){
			yyerror("LOOPHEADER Instruction error!");
		}
	}
	|LOOPHEADER number COMMA number COMMA number COMMA number NEWLINE{
		if(!ir_ptr->create_instr_loopheader(coord_x, coord_y, $2, $4, $6, $8)){
			yyerror("LOOPHEADER Instruction error!");
		}
	}
	;

instr_looptail:
	LOOPTAIL number number number NEWLINE{
		if(!ir_ptr->create_instr_looptail(coord_x, coord_y, $2, $3, $4)){
			yyerror("LOOPTAIL Instruction error!");
		}
	}
	|LOOPTAIL number COMMA number COMMA number NEWLINE{
		if(!ir_ptr->create_instr_looptail(coord_x, coord_y, $2, $4, $6)){
			yyerror("LOOPTAIL Instruction error!");
		}
	}
	;

instr_swb:
	SWB number number number number number number NEWLINE{
		if(!ir_ptr->create_instr_swb(coord_x, coord_y, $2, $3, $4, $5, $6, $7)){
			yyerror("SWB Instruction error!");
		}
	}
	|SWB number COMMA number COMMA number COMMA number COMMA number COMMA number NEWLINE{
		if(!ir_ptr->create_instr_swb(coord_x, coord_y, $2, $4, $6, $8, $10, $12)){
			yyerror("SWB Instruction error!");
		}
	}
	;

instr_branch:
	BRANCH number number NEWLINE{
		if(!ir_ptr->create_instr_branch(coord_x, coord_y, $2, $3)){
			yyerror("BRANCH Instruction error!");
		}
	}
	|BRANCH number COMMA number NEWLINE{
		if(!ir_ptr->create_instr_branch(coord_x, coord_y, $2, $4)){
			yyerror("BRANCH Instruction error!");
		}
	}
	;

instr_jump:
	JUMP number NEWLINE{
		if(!ir_ptr->create_instr_jump(coord_x, coord_y, $2)){
			yyerror("JUMP Instruction error!");
		}
	}
	;

instr_sramread:
	SRAMREAD number number number number number number number number number number number number number number number number number NEWLINE{
		if(!ir_ptr->create_instr_sramread(coord_x, coord_y, $2, $3, $4, $5, $6, $7, $8, $9, $10, $11, $12, $13, $14, $15, $16, $17, $18)){
			yyerror("SRAMREAD Instruction error!");
		}
	}
	|SRAMREAD number COMMA number COMMA number COMMA number COMMA number COMMA number COMMA number COMMA number COMMA number COMMA number COMMA number COMMA number COMMA number COMMA number COMMA number COMMA number COMMA number NEWLINE{
		if(!ir_ptr->create_instr_sramread(coord_x, coord_y, $2, $4, $6, $8, $10, $12, $14, $16, $18, $20, $22, $24, $26, $28, $30, $32, $34)){
			yyerror("SRAMREAD Instruction error!");
		}
	}
	;

instr_sramwrite:
	SRAMWRITE number number number number number number number number number number number number number number number number number NEWLINE{
		if(!ir_ptr->create_instr_sramwrite(coord_x, coord_y, $2, $3, $4, $5, $6, $7, $8, $9, $10, $11, $12, $13, $14, $15, $16, $17, $18)){
			yyerror("SRAMWRITE Instruction error!");
		}
	}
	|SRAMWRITE number COMMA number COMMA number COMMA number COMMA number COMMA number COMMA number COMMA number COMMA number COMMA number COMMA number COMMA number COMMA number COMMA number COMMA number COMMA number COMMA number NEWLINE{
		if(!ir_ptr->create_instr_sramwrite(coord_x, coord_y, $2, $4, $6, $8, $10, $12, $14, $16, $18, $20, $22, $24, $26, $28, $30, $32, $34)){
			yyerror("SRAMWRITE Instruction error!");
		}
	}
	;

instr_route:
	ROUTE number number number number number number number number NEWLINE{
		if(!ir_ptr->create_instr_route(coord_x, coord_y, $2, $3, $4, $5, $6, $7, $8, $9)){
			yyerror("ROUTE Instruction error!");
		}
	}
	|ROUTE number COMMA number COMMA number COMMA number COMMA number COMMA number COMMA number COMMA number NEWLINE{
		if(!ir_ptr->create_instr_route(coord_x, coord_y, $2, $4, $6, $8, $10, $12, $14, $16)){
			yyerror("ROUTE Instruction error!");
		}
	}
	;

instr_halt:
	HALT NEWLINE{
		if(!ir_ptr->create_instr_halt(coord_x, coord_y)){
			yyerror("HALT Instruction error!");
		}
	}
	;

number:
	INTEGER{
		$$ = $1;
	}
	| number MUL number{
		$$ = $1*$3;
	}
	| number DIV number{
		$$ = $1/$3;
	}
	| number POW number{
		$$ = (int)pow($1,$3);
	}
	| number ADD number{
		$$ = $1+$3;
	}
	| number SUB number{
		$$ = $1-$3;
	}
	| PAL number PAR{
		$$ = $2;
	}
	;

coordinate_list:
	BRACKET_L coordinate{
		vector<vector<int>>* p = new vector<vector<int>>();
		p->push_back((*static_cast<vector<int>*>($2)));
		delete $2;
		$$ = p;
	}
	| coordinate_list COMMA coordinate{
		vector<vector<int>>* p = static_cast<vector<vector<int>>*>($1);
		p->push_back(*static_cast<vector<int>*>($3));
		delete $3;
		$$ = p;
	}
	;

coordinate:
	SHEVRON_L number COMMA number SHEVRON_R{
		vector<int>* c = new vector<int>();
		c->push_back($2);
		c->push_back($4);
		$$ = c;
	}
	;

variables:
	{
	}
	| variable{
	}
	| variables variable{
	}
	;
	
variable:
	VARIABLE distribution location array NEWLINE{
		shared_ptr<IrManasVar> v = ir_ptr->create_var($1, (DistrType)$2, *static_cast<vector<vector<int>>*>($3), *static_cast<vector<int>*>($4));
		delete $3;
		delete $4;
		if(!v){
			yyerror("Variable error!");
		}
	}
	;

distribution:
	FULL_DISTR{
		$$ = $1;
	}
	| EVEN_DISTR{
		$$ = $1;
	}
	;

location:
	coordinate_list BRACKET_R{
		$$ = $1;
	}
	;

array:
	number_list BRACKET_R{
		$$ = $1;
	}
	| ZEROS number{
		vector<int>* p = new vector<int>($2, 0);
		$$ = p;
	}
	| ONES number{
		vector<int>* p = new vector<int>($2, 1);
		$$ = p;
	}
	;

number_list:
	BRACKET_L number{
		vector<int>* p = new vector<int>();
		p->push_back($2);
		$$ = p;
	}
	| number_list COMMA number{
		vector<int>* p = static_cast<vector<int>*>($1);
		p->push_back($3);
		$$ = p;
	}
	;

parse_error:
	LEXERROR{
		yyerror("Lexical error!");
	}
	| error
	;

%%

static void yyerror(const char* message){
	string msg(message);
	LOG(FATAL) << "Error near line " << yylineno-1 << " : " << msg;
}
	


