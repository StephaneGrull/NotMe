from PIL import Image
import os

img = Image.open('/Users/7511036V/Documents/Perso/ASM/HECTOR/NOTME/ecran-jeu-hector-v02.png')

def get_color(val, x, y):
    if val == (0, 0, 0, 255): # noir
        return 0
    elif val == (255, 255, 0, 255): # jaune
        return 1
    elif val == (0, 0, 255, 255): # bleu
        return 2
    elif val == (255, 255, 255, 255): # blanc
        return 3
    else:
        print("le pixel ", val, x, y)


# 0: black
# 1: red
# 2: green
# 3: white
#palette = [0, 3, 4, 7]

with open("/Users/7511036V/Documents/Perso/ASM/HECTOR/NOTME/token.asm", "wb") as o:

    db = []
    print(img.height)
    print(img.width)
    for y in range(img.height):
        octets = 0
        for x in range(0, img.width, 4):
            octets +=1
            #print(img.getpixel((x+3, y)), img.getpixel((x+2, y)), img.getpixel((x+1, y)), img.getpixel((x, y)))
            val1 = get_color(img.getpixel((x+3, y)), x, y)
            #print("x,y:" + str(x) +","+str(y)+"__val1:" + str(img.getpixel((x+3, y))))
            val2 = get_color(img.getpixel((x+2, y)), x, y)
            val3 = get_color(img.getpixel((x+1, y)), x, y)
            val4 = get_color(img.getpixel((x, y)), x, y)
            val = val1*16*4 + val2*16 + val3*4 + val4
            db.append(str(hex(val)))
        print("octets:", octets)
    line = '    db '
    compteur = 0
    for y in range(int(len(db))):
        if len(db[y])>3:
            line += db[y][0:2]+db[y][-2:].upper()
        else:
            line += db[y][0:2]+db[y][-1:].upper()
        if y != int(len(db))-1:
            line += ", "
        if y != 0 and y % 59 == 0:
            line +="\n"
            line +="db "
        compteur +=1
    o.write(line.encode())
    print(line)