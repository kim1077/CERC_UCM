from numpy import *
from scipy.interpolate import *
from matplotlib.pyplot import *
def ndmap(ix_grid):
    n=len(ix_grid)
    for x_ndinx in ndindex(tuple(ngrid_x)): # x_ndinx = n-dimensional index of ndgrid, e,g, (2,3,4)
        
        xk=mat(zeros((n,1)))
        for i in range(n): # just define x vector as a "k"th node according to an python-defined index on x-grid
            xk[i]=ix_grid[i][x_ndinx[i]] #=X[i][x_ndinx] << e.g. (2,3). find the 2nd, i.e the first x_ndix, element of the grid for the "ith" x
        dummy=1e10;   # initital estimation of optitmal cost to go from k to N given xi
        print(xk.T)                        
        Vkp1funcofx=RegularGridInterpolator(ix_grid,Vok[N-kb+1],method='nearest')
        for u_ndinx in ndindex(tuple(ngrid_u)): # just define u vector as a "u"th node according to an python-defined index on u-grid
            uk=nan*mat(zeros((m,1)))
            for j in range(m):
                uk[j]=ju_grid[j][u_ndinx[j]] ## e.g.(3,4), find the 3rd (=1st u_ndinx) element of the jth u-grid
            
            xkp1=f(xk,uk,A,B) ;# next state
            if g_feasible(xk,uk):
                Vokp1xp1=Vkp1funcofx(squeeze(xk.T))
                # Vokp1xp1=interpn(ix_grid,Vok[N-kb+1],xkp1.T.tolist()[0],bounds_error=False,fill_value=1e10); # optimal cost to go from k+1 to N at xkp1
                # Note it is a known function, e.g. terminal cost if kb=1
                Vkxu=phi(xk,uk)+Vokp1xp1; # a cost from k to N at xi with uj 
            else: # infeasible
                Vkxu=1e10
            
            
            if Vkxu<dummy:
                dummy=Vkxu;
                
                for j in range(m):
                    Uok[j][N-kb][x_ndinx]=uk[j];
        
            Vok[N-kb][x_ndinx]=dummy;
                
def V(x,y): # [-1,1] -->R
    # domain constraint
    x=min(max(x,-1),1)
    y=min(max(y,-1),1)
    v=x**2+0.1*y**2
    return(v)
    
x_grid=linspace(-1.5,1.5,20)
y_grid=linspace(-1.5,1.5,20)

Vdata=nan*ndarray((len(x_grid),len(y_grid)))
for index in ndindex(Vdata.shape):
    i=index[0]
    j=index[1]
    Vdata[i,j]=V(x_grid[i],y_grid[j])
# Validation

hatV= RegularGridInterpolator((x_grid,y_grid),Vdata)

testhatV=[]
testexcV=[]
for i in range(1000):
    x0=random.random(2)
    testhatV.append(hatV((x0[0],x0[1])))
    testexcV.append(V(x0[0],x0[1]))
    
plot(vstack(testexcV),vstack(testhatV),'o')
grid(True)