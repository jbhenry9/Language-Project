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

<rgbval> -> rgb "(" <intval> "," <intval> "," <intval> ")"

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
    | IntVal Int
    deriving (Show, Eq)

data RGB
    = RGB Int Int Int
    deriving (Show, Eq)

type Env = [(Var, Value)]