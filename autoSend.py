import os
import pandas as pd
import webbrowser as web
import time
import pyautogui

def procesar_mensajes(path):
    if not os.path.isfile(path):
        print(f"El archivo no existe: {path}")
        return

    df = pd.read_csv(path)
    contadorSI = 0
    contadorNO = 0

    for fila in df.index:
        try:
            if df.at[fila, "enviar"] == "SI":
                contadorSI += 1
                web.open(df.at[fila, "enlace"])
                time.sleep(12)  # Espera de 10 segundos entre cada apertura de enlace

                pyautogui.press('enter')  # Simula la presión de la tecla Enter
                pyautogui.write('\n')
                time.sleep(5)  # Espera adicional de 6 segundos

                pyautogui.press('enter')  # Simula la presión de la tecla Enter
                time.sleep(2)  # Espera de 1 segundo para asegurar que la pestaña se cierre

                pyautogui.hotkey('ctrl', 'w')
                time.sleep(1)  # Espera de 1 segundo para asegurar que la pestaña se cierre

                pyautogui.press('enter')  # Simula la presión de la tecla Enter
                time.sleep(2)  # Espera de 1 segundo para asegurar que la pestaña se cierre

            else:
                contadorNO += 1
                print("No enviado.")
            print(f"Último envío -> {contadorSI} / {df.count()[0]}")
            
        except Exception as e:
            print(f"Error al procesar la fila {fila}: {e}")

    print(f"Se enviaron {contadorSI} de {len(df)} mensajes.")
    print(f"No se enviaron {contadorNO} de {len(df)} mensajes.")

# Reemplaza el siguiente camino con la ruta correcta de tu archivo CSV
path = r"Whatsapp_moodle_messages.csv"
procesar_mensajes(path)
