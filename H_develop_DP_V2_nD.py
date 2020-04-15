#==============================================================================
# object, general code
#==============================================================================
from numpy import *
from scipy.interpolate import *
from control.matlab import *
from matplotlib.pyplot import *
import matplotlib.pyplot as pp
from H_utility import *

def phi(x,u): # suppose phi has a domain constraint
    #x=H_bound(x,xl,xu)
    #u=H_bound(u,ul,uu)
    stagecost=x.T*Q*x+u.T*R*u;
    return stagecost
    
def f(xk,uk,A,B):
    xkp1=A*xk+B*uk;
    return xkp1

def M(x):
    Miercost=x.T*Q*x
    return Miercost
    
def g_feasible(xk,uk):
    feasible=True #all(all((-1<=xk) & (xk<=1) & (-1 <=uk) & (uk<=1)))
    return feasible

A=0.98*mat(eye(2))
B=1*mat(eye(2))
Q=mat(eye(2))
R=1e-2*mat(eye(2))

xl=0
xu=1
ul=-1
uu=1
ix_grid=[linspace(xl,xu,2),linspace(xl,xu,2)]
ju_grid=[linspace(ul,uu,11),linspace(ul,uu,5)]

N=10;

n=len(ix_grid)    
m=len(ju_grid)
# specify number of grid vector for x
ngrid_x=zeros(n)
for i in range(n):
    ngrid_x[i]=len(ix_grid[i])
ngrid_x=ngrid_x.astype(int)

ngrid_u=zeros(m)
for j in range(m):
    ngrid_u[j]=len(ju_grid[j])
ngrid_u=ngrid_u.astype(int)


Vok=list() # Vok[k](x1,x2,...) : (R*R*R*...) --> R
for k in range(N+1):
    if k is N:
        dummy=0.*ndarray(ngrid_x)
        for x_ndinx in ndindex(tuple(ngrid_x)):
            xk=mat(zeros((n,1)))
            for i in range(n): # just define x vector as a "k"th node according to an python-defined index on x-grid
                xk[i]=ix_grid[i][x_ndinx[i]] #=X[i][x_ndinx] << e.g. (2,3). find the 2nd, i.e the first x_ndix, element of the grid for the "ith" x
            dummy[x_ndinx]=M(xk)        
            
        Vok.append(dummy);   # Terminal cost at x (x,N)
    else:    
        Vok.append(nan*ndarray(ngrid_x));   # Optimal cost to go from k to N at x (x,k)|--> V*(x,k) in R
Uok=list()
for j in range(m):
    Ujok=list() # Uok[time=k][input number=j](x1,x2,..)--> (u1,u2,...)
    for k in range(N):    
        Ujok.append(nan*ndarray(ngrid_x));   # Optimal input map (x,k)|--> uk that is u*(x,k) in Rm
    Uok.append(Ujok) # repeat list of the list which is Ujok
    
for kb in range(1,N+1):
    
    for x_ndinx in ndindex(tuple(ngrid_x)): # x_ndinx = n-dimensional index of ndgrid, e,g, (2,3,4)
        
        xk=mat(zeros((n,1)))
        for i in range(n): # just define x vector as a "k"th node according to an python-defined index on x-grid
            xk[i]=ix_grid[i][x_ndinx[i]] #=X[i][x_ndinx] << e.g. (2,3). find the 2nd, i.e the first x_ndix, element of the grid for the "ith" x
        dummy=1e10;   # initital estimation of optitmal cost to go from k to N given xi
        print 'new state start ===================', x_ndinx, xk.T
        Vkp1funcofx=RegularGridInterpolator((ix_grid[0],ix_grid[1]),Vok[N-kb+1],bounds_error=False,fill_value=1e10)
        print 'Vok', Vok[N-kb+1]
        print 'u iter starts =============================' 
        for u_ndinx in ndindex(tuple(ngrid_u)): # just define u vector as a "u"th node according to an python-defined index on u-grid
            uk=nan*mat(zeros((m,1)))
            for j in range(m):
                uk[j]=ju_grid[j][u_ndinx[j]] ## e.g.(3,4), find the 3rd (=1st u_ndinx) element of the jth u-grid
            
            xkp1=f(xk,uk,A,B) ;# next state
            if g_feasible(xk,uk):
                Vokp1xp1=Vkp1funcofx(xkp1.T.tolist()[0])
                # Vokp1xp1=interpn(ix_grid,Vok[N-kb+1],xkp1.T.tolist()[0],bounds_error=False,fill_value=1e10); # optimal cost to go from k+1 to N at xkp1
                # Note it is a known function, e.g. terminal cost if kb=1
                Vkxu=phi(xk,uk)+Vokp1xp1; # a cost from k to N at xi with uj 
            else: # infeasible
                Vkxu=1e10
            
            print u_ndinx, 'trial', uk.T
            print 'xk', xk.T, 'xkp1', xkp1.T
            print 'Vk(x,j)', Vkxu
            print 'phi', phi(xk,uk), 'Vokp1xp1', Vokp1xp1
            if Vkxu<dummy:
                dummy=Vkxu;
                print 'updated ====='
                for j in range(m):
                    Uok[j][N-kb][x_ndinx]=uk[j];
                    
                    print 'uk', uk.T
                    print 'uopt', Uok[j][N-kb]
                    
            Vok[N-kb][x_ndinx]=dummy;
        print 'opt', Uok[0][N-kb][x_ndinx],Uok[1][N-kb][x_ndinx]
        # end of optimization (all inputs) at a given x and k
    #end of optimization for all x at k
#end of optimization for all k


##
x=nan*random.random((N,n))
UTR=nan*random.random((N-1,m))
Uoexct=nan*random.random((N-1,m))
x[0,:]=ones((1,n));
K=list()
T=arange(N)
# exact solution
(P,Lam,Kopt)=dare(A,B,Q,R)
print Kopt


#%% 
for k in range(N-1):
    for j in range(m):
        Uoptfuncofx=RegularGridInterpolator(ix_grid,Uok[j][k],bounds_error=False)#,fill_value=10)
        UTR[k,j]=Uoptfuncofx(squeeze(x[k,:]));
    Uoexct[k,:]=-(mat(Kopt)*mat(x[k,:]).T).T
    xkp1=f(mat(x[k,:]).T,mat(UTR[k,:]).T,A,B)
    x[k+1,:]=array(xkp1.T)
close('all')
figure(1)
subplot(211)
plot(T.T,x,'o-');grid(True);
subplot(212)
plot(T[:-1],UTR,'r*--',linewidth=5);#ylim([-1,1.5])
plot(T[:-1],Uoexct,'o--')
grid(True)