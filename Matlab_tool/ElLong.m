function [CQUAD,CROD] = ElLong (SECTION,L,V)

Prop = [7*ones(1,9) 8*ones(1,13) 9*ones(1,10) 10*ones(1,10) 11*ones(1,8) 12*ones(1,8)];
S = L*V;
c = 1;
r = 1;
l1 = size(SECTION(57).x,2)/V;
l2 = L - l1;

for k = 1:55
        CROD(c).P    = Prop(k)+6;
        CROD(c).n1   = SECTION(k).ID(1);
        CROD(c).n2 = SECTION(k+1).ID(1);
        CROD(c+1).P  = Prop(k)+6;
        CROD(c+1).n1 = SECTION(k).ID(L);
        CROD(c+1).n2 = SECTION(k+1).ID(L);
        CROD(c+2).P  = Prop(k)+6;
        CROD(c+2).n1 = SECTION(k).ID(S-L+1);
        CROD(c+2).n2 = SECTION(k+1).ID(S-L+1);
        CROD(c+3).P  = Prop(k)+6;
        CROD(c+3).n1 = SECTION(k).ID(S);
        CROD(c+3).n2 = SECTION(k+1).ID(S);
        
        c = c + 4;
        
        for i = 1:V-1
            CQUAD(r).P  =  Prop(k);
            CQUAD(r).n1 =  SECTION(k+1).ID(1+(S-L*(V-1))*(i-1));
            CQUAD(r).n2 =  SECTION(k).ID(1+(S-L*(V-1))*(i-1));
            CQUAD(r).n3 =  SECTION(k).ID(1+(S-L*(V-1))*i);
            CQUAD(r).n4 =  SECTION(k+1).ID(1+(S-L*(V-1))*i);
            
            CQUAD(r+1).P  =  Prop(k);
            CQUAD(r+1).n1 =  SECTION(k+1).ID(L+(S-L*(V-1))*(i-1));
            CQUAD(r+1).n2 =  SECTION(k).ID(L+(S-L*(V-1))*(i-1));
            CQUAD(r+1).n3 =  SECTION(k).ID(L+(S-L*(V-1))*i);
            CQUAD(r+1).n4 =  SECTION(k+1).ID(L+(S-L*(V-1))*i);
            
            r = r + 2;
        end        
end

        CROD(c).P    = Prop(56)+6;
        CROD(c).n1   = SECTION(56).ID(1);
        CROD(c).n2 = SECTION(58).ID(1);
        CROD(c+1).P  = Prop(56)+6;
        CROD(c+1).n1 = SECTION(56).ID(L);
        CROD(c+1).n2 = SECTION(57).ID(l1);
        CROD(c+2).P  = Prop(56)+6;
        CROD(c+2).n1 = SECTION(56).ID(S-L+1);
        CROD(c+2).n2 = SECTION(58).ID(S-L+1);
        CROD(c+3).P  = Prop(56)+6;
        CROD(c+3).n1 = SECTION(56).ID(S);
        CROD(c+3).n2 = SECTION(57).ID(l1*V);
        
        c = c + 4;
        
        for i = 1:V-1
            CQUAD(r).P  =  Prop(56);
            CQUAD(r).n1 =  SECTION(58).ID(1+(S-L*(V-1))*(i-1));
            CQUAD(r).n2 =  SECTION(56).ID(1+(S-L*(V-1))*(i-1));
            CQUAD(r).n3 =  SECTION(56).ID(1+(S-L*(V-1))*i);
            CQUAD(r).n4 =  SECTION(58).ID(1+(S-L*(V-1))*i);
            
            CQUAD(r+1).P  =  Prop(56);
            CQUAD(r+1).n1 =  SECTION(57).ID(l1+(l1*V-l1*(V-1))*(i-1));
            CQUAD(r+1).n2 =  SECTION(56).ID(L+(S-L*(V-1))*(i-1));
            CQUAD(r+1).n3 =  SECTION(56).ID(L+(S-L*(V-1))*i);
            CQUAD(r+1).n4 =  SECTION(57).ID(l1+(l1*V-l1*(V-1))*i);
            
            r = r + 2;
        end
        
        CROD(c).P    = Prop(57)+6;
        CROD(c).n1   = SECTION(57).ID(l1);
        CROD(c).n2   = SECTION(58).ID(L);
        CROD(c+1).P  = Prop(57)+6;
        CROD(c+1).n1 = SECTION(57).ID(l1*V);
        CROD(c+1).n2 = SECTION(58).ID(S);
        
 c = c + 2;       
 
 for i = 1:V-1   
            CQUAD(r).P  =  Prop(57);
            CQUAD(r).n1 =  SECTION(58).ID(L+(S-L*(V-1))*(i-1));
            CQUAD(r).n2 =  SECTION(57).ID(l1+(l1*V-l1*(V-1))*(i-1));
            CQUAD(r).n3 =  SECTION(57).ID(l1+(l1*V-l1*(V-1))*i);
            CQUAD(r).n4 =  SECTION(58).ID(L+(S-L*(V-1))*i);
            
            r = r + 1;
 end


end