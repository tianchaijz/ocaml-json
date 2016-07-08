%token <int> INT
%token <float> FLOAT
%token <string> STRING
%token TRUE
%token FALSE
%token NULL
%token LEFT_BRACE
%token RIGHT_BRACE
%token LEFT_BRACK
%token RIGHT_BRACK
%token COLON
%token COMMA
%token EOF

%start <Json.value option> prog
%%

prog:
  | v = value { Some v }
  | EOF       { None }
  ;

value:
  | LEFT_BRACE; obj = object_fields; RIGHT_BRACE { `Assoc obj }
  | LEFT_BRACK; vl = array_values; RIGHT_BRACK   { `List vl }
  | s = STRING                                   { `String s }
  | i = INT                                      { `Int i }
  | x = FLOAT                                    { `Float x }
  | TRUE                                         { `Bool true }
  | FALSE                                        { `Bool false }
  | NULL                                         { `Null }
  ;

object_fields:
  | obj = rev_object_fields { List.rev obj }
  ;

rev_object_fields:
  | (* empty *)                                                  { [] }
  | k = STRING; COLON; v = value                                 { [(k, v)] }
  | obj = rev_object_fields; COMMA; k = STRING; COLON; v = value { (k, v) :: obj }
  ;

array_values:
  | (* empty *)     { [] }
  | vl = rev_values { List.rev vl }
  ;

rev_values:
  | v = value                         { [v] }
  | vl = rev_values; COMMA; v = value { v :: vl }
  ;
