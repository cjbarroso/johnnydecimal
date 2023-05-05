Mi johnny decimal plus

Carpetas de alto nivel basadas en PARA.
Dentro de proyectos, 11 es laboral.
Dentro de cada proyecto hay otro PARA exclusivo para proyectos. Es global, para cualquier proyecto personal o laboral. A lo sumo los personales no contendran algunas cosas pero los numeros son fijos.

Dentro de cada carpeta, desde la raiz, hay archivos info.yaml que pueden contener:
Name:
Description
URL: Esta es la URL por default asociada al numero en cuestion. Por ejemplo:
11/info.yaml tiene la URL de un archivo .md que explica la categoria
11/11.01/info.yaml tiene la URL de un archivo .md que explica globalmente el proyecto.
23/23.05 Tiene la URL de un archivo .md que explica la categoria
/info.yaml tiene la URL de un archivo que explica el sistema (que probablemente vive en 00.00)
Esto me permite tener un script que, ingresando un numero, pueda acceder rapidamente a la informacion o a otras cosas. Por ejemplo, si en un proyecto tengo un numero fijo 01.03 “ticket system” con la informacion sobre el sistema de tickets de ese proyecto, el info.yaml de ese directorio tiene una URL que abre el sistema de tickets. Entonces ingresando por ejemplo 11.01.01.03 me llevaria a la URL del sistema de tickets del proyecto 11.01. Como esto puedo tener por ejemplo canales de comunicacion, listas de correo, slack, etc.
El sistema de numeros funciona para cualquier cosa, por ejemplo podria tener 03.09 Technical proposals y al ingresar eso que abra la carpeta de Drive con todas las propuestas, o incluso mejor, una busqueda en drive que busque por el tag 03.09.
