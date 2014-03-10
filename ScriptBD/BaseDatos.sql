create Database oite;
use oite

CREATE TABLE IF NOT EXISTS `tbsolicitudatencion` (
  `Id` varchar(12) NOT NULL default '',
  `oficina` varchar(255) default NULL,
  `fecha` datetime default NULL,
  `personal` varchar(255) default NULL,
  `insidencia` varchar(255) default NULL,
  `TecResponsable` varchar(255) default NULL,
  `solucion` varchar(255) default NULL,
  PRIMARY KEY  (`Id`)
)  ;

CREATE TABLE IF NOT EXISTS `tb_cod` (
  `Id` int(11) NOT NULL auto_increment,
  `myear` varchar(4) default NULL,
  `nro` int(11) default NULL,
  `tabla` varchar(255) default NULL,
  PRIMARY KEY  (`Id`);
) 

CREATE   PROCEDURE `GeneraCodigo`(in NomTabla varchar(255),out retorno int )
begin
     declare YearActual varchar(10) ; declare Contador  int   ;
     set YearActual = year(CURDATE()) ;
     if not exists(select * from tb_cod where tabla = NomTabla )   THEN       
        insert into tb_cod (myear,nro,tabla)values(year(CURDATE()) , 1 ,NomTabla); 
        select 1  into retorno;     
     else          
        if exists(select * from tb_cod where myear = YearActual and tabla = NomTabla )  THEN    
           select (nro + 1) as  Contador from tb_cod where myear = YearActual and tabla = NomTabla into retorno  FOR UPDATE   ;           
           update tb_cod set nro = (nro + 1) where myear = YearActual and tabla = NomTabla ;                       
           
        else   
          update tb_cod set nro  = 1  , myear = YearActual where tabla = NomTabla ;   
           select 1    into retorno;      
        end if;           
     end if;        
end;

 
 
CREATE FUNCTION  fuc_codigo( )
RETURNS varCHAR(50)  DETERMINISTIC
begin
declare   codigo  varchar(12); 
     set @nomtabla = 'tbsolicitudatencion'; 
     CALL GeneraCodigo( @nomtabla,  @nro );     
     set codigo =( concat(year(CURDATE()) ,RIGHT(concat('00000000',@nro),8))   )  ;
     
                 
RETURN codigo;        
end;