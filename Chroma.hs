{-

<prog> -> [<stmt>]

<stmt> -> swatch <var> "=" <expr>
        | <var> "=" <expr>
        | print <expr>

<expr> -> mix "(" <expr> "," <expr> ")"
        | shade "(" <expr> "," <intval> ")"
        | tint "(" <expr> "," <intval> ")"
        | <var>
        | <rgbval>
        | <swatchval>

<swatchval> -> swatch <rgbval>

<rgbval> -> rgb "(" <intval> "," <intval> "," <intval> ")"

<intval> -> int

<env> -> [(<var>, <swatchval>)]

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
    | Shade Expr Int
    | Tint Expr Int
    | VarExpr Var
    | RGBVal Int Int Int
    | SwatchVal Int Int Int
    deriving (Show, Eq)

type Env = [(Var, Expr)]