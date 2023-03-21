#pip install pandas
#pip install pycopy-webbrowser
import pandas as pd
import webbrowser as web
import time




path="C:/Users/Rodney/PycharmProjects/TecnoTest/_DataMoodle_Febrero2023.csv"
df=pd.read_csv(path)
contadorSI =0
contadorNO =0

for fila in df.index:

    if df["Enviar"][fila]=="SI":
        contadorSI+=1
        web.open(df["enlace"][fila])
        time.sleep(10)

    else:
        contadorNO +=1
        print("No enviado.")

    print(f"ultimo envio -> {contadorSI} ")
    # time.sleep(9000)

    # web.get(chrome_path).open("https://web.whatsapp.com/send?phone=" + celular + "&text=" + mensaje)
print(f"Se envio {contadorSI} de {str(df.axes[0])}")
print(f"No se envio {contadorNO} de {str(df.axes[0])}")