{-

<prog> -> [<stmt>]

<stmt> -> swatch <var> "=" <expr>
        | <var> "=" <expr>
        | print <expr>

<expr> -> mix "(" <expr> "," <expr> ")"
        | shade "(" <expr> "," <expr> ")"
        | tint "(" <expr> "," <expr> ")"
        | <var>
        | <value>

<value> -> <rgbval>
         | <intval>
         | <hexval>

<rgbval> -> rgb "(" <intval> "," <intval> "," <intval> ")"

<hexval> -> hex "(" <hexpair> "," <hexpair> "," <hexpair> )"

<hexpair> -> hexnum hexnum

<hexnum> -> 0 | 1 | 2 | 3 | 4 | 5 | 6 | 7 | 8 | 9
          | a | b | c | d | e | f
          | A | B | C | D | E | F

<intval> -> int

<env> -> [(<var>, <value>)]

-}

type Var = String

data Program
    = Program [Stmt]
    deriving (Show, Eq)

data Stmt
    = Declare Var Expr
    | Assign Var Expr
    | Print Expr
    deriving (Show, Eq)

data Expr
    = Mix Expr Expr
    | Shade Expr Expr
    | Tint Expr Expr
    | VarExpr Var
    | ValueExpr Value
    deriving (Show, Eq)

data Value
    = RGBVal RGB
    | HexVal HEX
    | IntVal Int
    deriving (Show, Eq)

data RGB
    = RGB Int Int Int
    deriving (Show, Eq)

data HEX
    = HEX String String String

type Env = [(Var, Value)]


{-
Program
  [ Declare "sky" (ValueExpr (RGBVal (RGB 100 150 255)))
  , Assign "sky" (Tint (VarExpr "sky") (ValueExpr (IntVal 20)))
  , Print (VarExpr "sky")
  ]
  -}