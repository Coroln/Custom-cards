"""Python script for automatically adding .lua files in a prior chosen folder
Made by creasycat | co. coroln"""
import os
from tkinter import Tk
from tkinter.filedialog import askdirectory

def get_integer_input(prompt):
    while True:
        try:
            value = int(input(prompt))
            return value
        except ValueError:
            print("I HOB JESACHT ZAHL/NUMBER UND NICH TOASTBROAT! YA MAE!")
            #Danke coroln :D | Thanks coroln

def get_string_input(prompt):
    while True:
        try:
            string = input(prompt)
            return string
        except ValueError:
            print("I HOB JESACHT NAME UND NICH TOASTBROAT! YA MAE!")

def select_folder():
    root = Tk()
    root.withdraw()
    folder_path = askdirectory(title="Ordner auswählen")
    return folder_path

def create_lua_files(folder_path, n, start_number):
    # Ordner erstellen, falls er noch nicht existiert | Adding a folder, if it does not exist, tbh, WHY?
    if not os.path.exists(folder_path):
        os.makedirs(folder_path)

    # Überprüfen, ob die Dateien existieren | checking if allready existent in root folder
    file_status = []  # Liste zur Speicherung des Status jeder Datei | List for filestatus
    existing_count = 0  # Zähler für die Anzahl der existierenden Dateien | counter

    for i in range(n):
        file_number = start_number + i
        file_name = f"c{file_number}.lua"
        file_path = os.path.join(folder_path, file_name)

        # Überprüfen, ob die Datei existiert | the file checker
        if os.path.exists(file_path):
            file_status.append(1)
            print(file_number,"Existiert")
            existing_count += 1
        else:
            file_status.append(0)
            print(file_number,"Existiert nicht")

    # Anzahl der existierenden Dateien ausgeben | eject number of allready existing files to know how much more to add a second time
    print("Anzahl der existierenden Dateien | Number of existing files:", existing_count)
    
    # Alle Dateien erstellen | create files
    for i in range(n):
        file_number = start_number + i
        file_name = f"c{file_number}.lua"
        file_path = os.path.join(folder_path, file_name)

        # .lua-Datei erstellen, falls sie nicht existiert | create
        if not os.path.exists(file_path):
            with open(file_path, 'w') as file:
                file.write(f"--CARD_NAME\n")
                file.write(f"--Script by: {author_name}\n")
                file.write("function s.initial_effect(c)\n")
                file.write("end\n")
                pass
            print(f"Die Datei {file_name} wurde erstellt.")

    return file_status

"""def create_lua_files(folder_path, n, start_number):
    # Ordner erstellen, falls er noch nicht existiert
    if not os.path.exists(folder_path):
        os.makedirs(folder_path)

    # .lua-Dateien erstellen
    for i in range(n):
        file_name = f"c{start_number + i}.lua"
        file_path = os.path.join(folder_path, file_name)

         # Überprüfen, ob die Datei bereits existiert
        if os.path.exists(file_path):
            print(f"Die Datei {file_name} existiert bereits.")

            # Neue Startzahl abfragen
            new_start_number = get_integer_input("Gib eine neue Startzahl ein, die Bastarde haben die Zahl schon: ")
            return create_lua_files(folder_path, n, new_start_number)

        else:
            # .lua-Datei erstellen
            
            with open(file_path, 'w') as file:
                pass  # Leeren Inhalt schreiben
            print(f"Die Datei {file_name} wurde erstellt.")

    print(f"{n} .lua-Dateien wurden erfolgreich erstellt.")"""
print("You are about to select a folder to deposit the created .lua files, they will allready contain 2 comments, the second is your author name.")
print("For questions and additions to this code, please @creasycat in Discord.")
input("Press any key except the one we all know to troll our unknowing users to select a folder.")
print("")
# Ordner auswählen
folder_path = select_folder()

# Eingabe der Parameter
n = get_integer_input("Anzahl dateien? | Insert number of files needed: ")
print("You are creating", n,"files")

# Beispielaufruf
start_number = get_integer_input("Startzahl?: | What is your starting number? ")
print("Starting generation at: ", start_number)

author_name = get_string_input("What is your Name? Press Enter to leave blank: ")
print("Your Name is:", author_name)
# Dateien erstellen
if folder_path:
    create_lua_files(folder_path, n, start_number)
    print("Ordner | Folder :",folder_path)
else:
    print("Kein Ordner ausgewählt. | No folder found")

input("Drücke Enter zum Beenden... | Press Enter to Exit")
