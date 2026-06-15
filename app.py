from flask import Flask, request, jsonify
import subprocess
import pymysql
import yagmail

path = "/run/user/1000/gvfs/google-drive:host=gmail.com,user=espol.baby/0AE5zgfuPuhc7Uk9PVA/Imagenes/"

app = Flask(_name_)
db = pymysql.connect(
    host='localhost',
    user='root',
    password='Admi_123',
    database='baby_espol',
    cursorclass=pymysql.cursors.DictCursor
)

def enviar_correo(correo, asunto, mensaje):
    sender_email = "espolbaby@gmail.com"
    sender_password = "uxdq qmmh auin zknt"
    yag = yagmail.SMTP(sender_email, sender_password)
    to = correo
    subject = asunto
    body = mensaje
    try:
        yag.send(to=to, subject=subject, contents=body)
        yag.close()
    except Exception as es:
        print("Error")

@app.route('/edit_bracelet', methods=['GET'])
def edit_bracelet():
    id_pulsera = request.args.get('id_pulsera')
    longitud = request.args.get('longitud')
    latitud = request.args.get('latitud')
    pulso = request.args.get('pulso')
    bateria = request.args.get('bateria')
    peligro = request.args.get('peligro')
    try:
        with db.cursor() as cursor:
            sql_pulsera = f"UPDATE bracelet SET longitud = '{longitud}', latitud = '{latitud}', pulso = '{pulso}', bateria = '{bateria}', peligro = '{peligro}' WHERE id_pulsera = '{id_pulsera}'"
            cursor.execute(sql_pulsera)
            db.commit()
            if peligro == '1' :
                sql_padre = f"SELECT usuario FROM user_child INNER JOIN child on user_child.id_nino = child.id_nino WHERE id_pulsera = '{id_pulsera}'"
                cursor.execute(sql_padre)
                datos1 = cursor.fetchall()
                for dic in datos1:
                    sql_correo = f"SELECT correo, tipo FROM user WHERE usuario = '{dic['usuario']}'"
                    cursor.execute(sql_correo)
                    datos2 = cursor.fetchall()
                    if(datos2[0]["tipo"] == 'representante'):
                        enviar_correo(datos2[0]["correo"], "Alerta de alejamiento", "Niño fuera de rango")
        return jsonify({'edit_bracelet': 'correcto'})
    except Exception as es:
        return jsonify({'error':'error'})

@app.route('/add_child', methods=['GET'])
def add_child():
    usuario = request.args.get('usuario')
    id_nino = request.args.get('id_nino')
    try:
        with db.cursor() as cursor:
            sql = f"INSERT INTO user_child values ('{usuario}', {id_nino}, 'A')"
            cursor.execute(sql)
            db.commit()
        return jsonify({'add_child': 'correcto'})
    except Exception as es:
        return jsonify({'error':'error'})


@app.route('/remove_child', methods=['GET'])
def remove_child():
    usuario = request.args.get('usuario')
    id_nino = request.args.get('id_nino')
    try:
        with db.cursor() as cursor:
            sql = f"DELETE FROM user_child WHERE usuario = '{usuario}' AND id_nino = '{id_nino}'"
            cursor.execute(sql)
        return jsonify({'remove_child': 'correcto'})
    except Exception as es:
        return jsonify({'error':'error'})

@app.route('/user', methods=['GET'])
def user():
    tipo = request.args.get('tipo')
    try:
        with db.cursor() as cursor:
            sql = f"SELECT usuario, contrasena, nombre, apellido, correo, telefono, tipo FROM user WHERE tipo = '{tipo}'"
            cursor.execute(sql)
            datos = cursor.fetchall()
        return jsonify({'user': datos})
    except Exception as es:
        return jsonify({'error':'error'})

@app.route('/edit_user', methods=['GET'])
def edit_user():
    usuario = request.args.get('usuario')
    telefono = request.args.get('telefono')
    contrasena = request.args.get('contrasena')
    try:
        with db.cursor() as cursor:
            sql = f"UPDATE user SET telefono = '{telefono}', contrasena = '{contrasena}' WHERE usuario = '{usuario}'"
            cursor.execute(sql)
            datos = cursor.fetchall()
        return jsonify({'edit_user': datos})
    except Exception as es:
        return jsonify({'error':'error'})

@app.route('/call', methods=['GET'])
def call():
    id_nino = request.args.get('id_nino')
    try:
        with db.cursor() as cursor:
            sql = f"SELECT telefono FROM user INNER JOIN user_child ON user.usuario = user_child.usuario AND id_nino = '{id_nino}' AND tipo = 'tutor'"
            cursor.execute(sql)
            datos = cursor.fetchall()
        return jsonify({'call': datos})
    except Exception as es:
        return jsonify({'error':'error'})

@app.route('/new_child', methods=['GET'])
def new_child():
    usuario = request.args.get('usuario')
    nombre = request.args.get('nombre')
    apellido = request.args.get('apellido')
    clase = request.args.get('clase')
    pulsera = request.args.get('pulsera')
    try:
        with db.cursor() as cursor:
            sql_child = f"INSERT INTO child (nombre, apellido, id_pulsera) VALUES ('{nombre}', '{apellido}', '{pulsera}')"
            cursor.execute(sql_child)
            db.commit()
            id_nino = cursor.lastrowid
            sql_userchild = f"INSERT INTO user_child (usuario, id_nino, clase) VALUES ('{usuario}', '{id_nino}', '{clase}')"
            cursor.execute(sql_userchild)
            db.commit()
        return jsonify({'new_child': 'correcto'})
    except Exception as es:
        return jsonify({'error':'error'})

@app.route('/edit_child', methods=['GET'])
def edit_child():
    id_nino = request.args.get('id_nino')
    nombre = request.args.get('nombre')
    apellido = request.args.get('apellido')
    clase = request.args.get('clase')
    pulsera = request.args.get('pulsera')
    try:
        with db.cursor() as cursor:
            sql_child = f"UPDATE child SET nombre = '{nombre}', apellido = '{apellido}', id_pulsera = '{pulsera}' WHERE id_nino = '{id_nino}'"
            cursor.execute(sql_child)
            db.commit()
            sql_userchild = f"UPDATE user_child SET clase = '{clase}' WHERE id_nino = '{id_nino}'"
            cursor.execute(sql_userchild)
            db.commit()
        return jsonify({'edit_child': 'correcto'})
    except Exception as es:
        return jsonify({'error':'error'})

@app.route('/delete_child', methods=['GET'])
def delete_child():
    id_nino = request.args.get('id_nino')
    try:
        with db.cursor() as cursor:
            sql_userchild = f"DELETE FROM user_child WHERE id_nino = '{id_nino}'"
            cursor.execute(sql_userchild)
            db.commit()
            sql_child = f"DELETE FROM child WHERE id_nino = '{id_nino}'"
            cursor.execute(sql_child)
            db.commit()
        return jsonify({'delete_child': 'correcto'})
    except Exception as es:
        return jsonify({'error':'error'})

@app.route('/child', methods=['GET'])
def child():
    usuario = request.args.get('usuario')
    try:
        with db.cursor() as cursor:
            sql = f"SELECT child.id_nino, nombre, apellido, id_pulsera, clase FROM child INNER JOIN user_child ON child.id_nino = user_child.id_nino AND usuario = '{usuario}'"
            cursor.execute(sql)
            datos = cursor.fetchall()
        return jsonify({'child':datos})
    except Exception as es:
        return jsonify({'error':'error'})

@app.route('/delete_activity', methods=['GET'])
def delete_activity():
    id_act = request.args.get('id_act')
    try:
        with db.cursor() as cursor:
            sql_photo = f"DELETE FROM photo WHERE id_act = '{id_act}'"
            cursor.execute(sql_photo)
            db.commit()
            sql_act = f"DELETE FROM activity WHERE id_act = '{id_act}'"
            cursor.execute(sql_act)
            db.commit()
            comando = ["rm", "-rf", path+str(id_act)]
            subprocess.run(comando)

        return jsonify({'delete_activity':'correcto'})
    except Exception as es:
        return jsonify({'error':'error'})

@app.route('/new_photo', methods=['POST'])
def new_photo():
    enlace = request.data
    id_act = request.args.get('id_act')
    numero = request.args.get('numero')
    with open(path+str(id_act)+"/"+numero+".jpg", 'wb') as archivo:
        archivo.write(enlace)
    comando = ["ls", path+str(id_act)]
    lista = subprocess.run(comando, capture_output=True, text=True)
    elementos = lista.stdout.strip().split('\n')
    indice = elementos[int(numero)-1]
    try:
        with db.cursor() as cursor:
            sql = f"INSERT INTO photo (enlace, id_act) VALUES ('{indice}', '{id_act}')"
            cursor.execute(sql)
            db.commit()
        return jsonify({'new_photo':'correcto'})
    except Exception as es:
        return jsonify({'error':'error'})

@app.route('/new_activity', methods=['GET'])
def new_activity():
    dia = request.args.get('dia')
    titulo = request.args.get('titulo')
    clase = request.args.get('clase')
    try:
        with db.cursor() as cursor:
            sql = f"INSERT INTO activity (dia, titulo, clase) VALUES ('{dia}', '{titulo}', '{clase}')"
            cursor.execute(sql)
            db.commit()
            id_act = cursor.lastrowid
            comando = ["mkdir", path+str(id_act)]
            subprocess.run(comando)
        return jsonify({'new_activity':id_act})
    except Exception as es:
        return jsonify({'error':'error'})

@app.route('/photo', methods=['GET'])
def photo():
    id_act = request.args.get('id_act')
    try:
        with db.cursor() as cursor:
            sql = f"SELECT enlace FROM photo WHERE id_act = '{id_act}'"
            cursor.execute(sql)
            datos = cursor.fetchall()
        return jsonify({'photo':datos})
    except Exception as es:
        return jsonify({'error':'error'})


@app.route('/activity', methods=['GET'])
def activity():
    clase = request.args.get('clase')
    try:
        with db.cursor() as cursor:
            sql = f"SELECT id_act, dia, titulo, clase FROM activity WHERE clase = '{clase}'"
            cursor.execute(sql)
            datos = cursor.fetchall()
        return jsonify({'activity':datos})
    except Exception as es:
        return jsonify({'error':'error'})

@app.route('/bracelet', methods=['GET'])
def bracelet():
    try:
        with db.cursor() as cursor:
            sql = f"SELECT id_pulsera, longitud, latitud, pulso, bateria, peligro FROM bracelet"
            cursor.execute(sql)
            datos = cursor.fetchall()
        return jsonify({'bracelet':datos})
    except Exception as es:
        return jsonify({'error':'error'})

@app.route('/new_message', methods=['GET'])
def new_message():
    usuario = request.args.get('usuario')
    mensaje = request.args.get('mensaje')
    id_anuncio = request.args.get('id_anuncio')
    try:
        with db.cursor() as cursor:
            sql = f"INSERT INTO message (usuario, mensaje, id_anuncio) VALUES ('{usuario}', '{mensaje}', '{id_anuncio}')"
            cursor.execute(sql)
            db.commit()
        return jsonify({'new_message':'correcto'})
    except Exception as es:
        return jsonify({'error':'error'})

@app.route('/message', methods=['GET'])
def message():
    id_anuncio = request.args.get('id_anuncio')
    try:
        with db.cursor() as cursor:
            sql = f"SELECT id_mensaje, usuario, mensaje FROM message WHERE id_anuncio = '{id_anuncio}' ORDER BY id_anuncio DESC"
            cursor.execute(sql)
            datos = cursor.fetchall()
        return jsonify({'message':datos})
    except Exception as es:
        return jsonify({'error':'error'})

@app.route('/delete_advertisement', methods=['GET'])
def delete_advertisement():
    id_anuncio = request.args.get('id_anuncio')
    try:
        with db.cursor() as cursor:
            sql_message = f"DELETE FROM message WHERE id_anuncio = '{id_anuncio}'"
            cursor.execute(sql_message)
            db.commit()
            sql_advertisement = f"DELETE FROM advertisement WHERE id_anuncio = '{id_anuncio}'"
            cursor.execute(sql_advertisement)
            db.commit()
        return jsonify({'delete_advertisement':'correcto'})
    except Exception as es:
        return jsonify({'error':'error'})

@app.route('/new_advertisement', methods=['GET'])
def new_advertisement():
    dia = request.args.get('dia')
    titulo = request.args.get('titulo')
    mensaje = request.args.get('mensaje')
    clase = request.args.get('clase')
    try:
        with db.cursor() as cursor:
            sql_anuncio = f"INSERT INTO advertisement (dia, titulo, clase) VALUES ('{dia}', '{titulo}', '{clase}')"
            cursor.execute(sql_anuncio)
            db.commit()
            id_anuncio = cursor.lastrowid
        return jsonify({'new_advertisement':id_anuncio})
    except Exception as es:
        return jsonify({'error':'error'})

@app.route('/advertisement', methods=['GET'])
def advertisement():
    clases_param = request.args.get('clase')
    try:
        with db.cursor() as cursor:
            if len(clases_param) == 1:
                sql = f"SELECT id_anuncio, dia, titulo, clase FROM advertisement WHERE clase = '{clases_param}' ORDER BY id_anuncio DESC"
            else:
                clases = [id for id in clases_param.split(",")]
                sql = f"SELECT id_anuncio, dia, titulo, clase FROM advertisement WHERE clase IN {tuple(clases)} ORDER BY id_anuncio DESC"
            cursor.execute(sql)
            datos = cursor.fetchall()
        return jsonify({'advertisement':datos})
    except Exception as es:
        return jsonify({'error':'error'})

@app.route('/class', methods=['GET'])
def clase():
    usuario = request.args.get('usuario')
    try:
        with db.cursor() as cursor:
            sql = f"SELECT clase FROM user_child WHERE usuario='{usuario}'"
            cursor.execute(sql)
            datos = cursor.fetchall()
        return jsonify({'class':datos})
    except Exception as es:
        return jsonify({'error':'error'})

@app.route('/recuperate', methods=['GET'])
def recuperate():
    usuario = request.args.get('usuario')
    try:
        with db.cursor() as cursor:
            sql = f"SELECT * FROM user WHERE usuario='{usuario}'"
            cursor.execute(sql)
            datos = cursor.fetchall()
        return jsonify({'recuperate':datos})
    except Exception as es:
        return jsonify({'error':'error'})

@app.route('/register', methods=['GET'])
def register():
    usuario = request.args.get('usuario')
    contrasena = request.args.get('contrasena')
    nombre = request.args.get('nombre')
    apellido = request.args.get('apellido')
    correo = request.args.get('correo')
    telefono = request.args.get('telefono')
    tipo = request.args.get('tipo')
    try:
        with db.cursor() as cursor:
            sql = "INSERT INTO user VALUES ('{usuario}', '{contrasena}', '{nombre}', '{apellido}', '{correo}', '{telefono}', '{tipo}')"
            cursor.execute(sql)
            db.commit()
        return jsonify({'register':'correcto'})
    except Exception as es:
        return jsonify({'error':'error'})

@app.route('/login', methods=['GET'])
def login():
    usuario = request.args.get('usuario')
    contrasena = request.args.get('contrasena')
    try:
        with db.cursor() as cursor:
            sql = f"SELECT * FROM user WHERE usuario = '{usuario}' AND contrasena = '{contrasena}'"
            cursor.execute(sql)
            datos = cursor.fetchall()
        return jsonify({'login':datos})
    except Exception as e:
        return jsonify({'error':'error'})

if _name_ == '_main_':
    app.run(debug=True)