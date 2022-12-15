"""from transformers import pipeline
qm = pipeline("question-answering")
result = qm({"question":"find x in this equation","context":"2x+1=0"})
print(result["answer"])"""

from os import listdir, rename,remove
#from rembg import remove
from json import dump
from random import randint, random
list_of_paths = ["./female/dress/", "./female/glasses/", "./female/hat/", "./female/hijab/", "./female/pants/",
                 "./female/shirts/", "./female/shoes/", "./male/hats/", "./male/pants/", "./male/shirts/",
                 "./male/shoes/", "./male/sunglasses/", "./child/dress/", "./child/pants/", "./child/shirts/", "./child/shoes/",
                 "./informatique/accessoires/", "./informatique/ordinateur/", "./informatique/phone/", "./informatique/stockage/"]
json_map = dict()
finaljson = open("./transformer.json", "w")

def parser(pattern: str) -> list:
    match pattern:
        case "informatique/accessoires/":
            return [["Standard"], [(255, 255, 255), (128, 128, 128), (0, 0, 0)], randint(35, 170)]
        case "informatique/ordinateur/":
            return [["Standard"], [(255, 255, 255), (128, 128, 128), (0, 0, 0)], randint(1550, 4000)]
        case "informatique/phone/":
            return [["Standard"], [(255, 255, 255), (128, 128, 128), (0, 0, 0)], randint(800, 3000)]
        case "informatique/stockage/":
            return [["Standard"], [(255, 255, 255), (128, 128, 128), (0, 0, 0)], randint(40, 250)]
        case "female/dress/":
            return [["XS", "S", "M", "L", "XL", "XXL", "1X", "2X", "3X"], [(127, 255, 212), (255, 255, 255), (0, 0, 0), (255, 0, 127), (255, 0, 0)], randint(40, 120)]
        case "female/glasses/":
            return [["Standard"], [(255, 215, 0), (0, 0, 255), (0, 0, 0)], randint(25, 45)]
        case "female/hat/":
            return [["Standard"], [(255, 255, 255), (0, 0, 0), (196, 164, 132)], randint(10, 35)]
        case "female/hijab/":
            return [["Standard"], [(255, 255, 255), (0, 0, 0), (255, 0, 0), (0, 255, 0), (128, 128, 128), (255, 192, 203), (255, 229, 180)], randint(13, 17)]
        case "female/pants/":
            return [[str(_) for _ in range(36, 53)], [(255, 255, 255), (0, 0, 0), (245, 245, 220), (21, 96, 189), (255, 105, 180)], randint(45, 120)]
        case "male/pants/":
            return [[str(_) for _ in range(36, 53)], [(21, 96, 189), (255, 255, 255), (0, 0, 0), (245, 245, 220)], randint(40, 90)]
        case "female/shoes/":
            return [[str(_) for _ in range(34, 47)], [(0, 0, 0), (255, 255, 255), (0, 100, 100), (255, 165, 0)], randint(65, 120)]
        case "female/shirts/":
            return [["XS", "S", "M", "L", "XL", "XXL", "1X", "2X", "3X"], [(255, 255, 255), (0, 0, 0), (255, 165, 0), (255, 105, 180)], randint(50, 180)]
        case "male/shirts/":
            return [["XS", "S", "M", "L", "XL", "XXL", "1X", "2X", "3X"], [(0, 0, 255), (255, 255, 255), (0, 0, 0), (128, 128, 128)], randint(35, 80)]
        case "male/shoes/":
            return [[str(_) for _ in range(34, 47)], [(0, 0, 0), (255, 255, 255), (0, 100, 100), (255, 105, 180)], randint(60, 150)]
        case "male/sunglasses/":
            return [["Standard"], [(0, 0, 0), (0, 0, 255)], randint(25, 50)]
        case "male/hats/":
            return [["Standard"], [(255, 255, 255), (0, 0, 0), (0, 0, 132)], randint(10, 20)]
        case "child/dress/":
            return [[str(_) for _ in range(12, 34)], [(127, 255, 212), (255, 255, 255), (0, 0, 0), (255, 0, 127), (255, 0, 0)], randint(40, 60)]
        case "child/pants/":
            return [[str(_) for _ in range(12, 34)], [(21, 96, 189), (255, 255, 255), (0, 0, 0), (245, 245, 220)], randint(25, 45)]
        case "child/shirts/":
            return [[str(_) for _ in range(12, 34)], [(255, 255, 255), (0, 0, 0), (255, 165, 0), (255, 105, 180), (0, 0, 255), (128, 128, 128)], randint(15, 35)]
        case "child/shoes/":
            return [[str(_) for _ in range(12, 34)], [(0, 0, 0), (255, 255, 255), (0, 100, 100), (255, 105, 180), (255, 165, 0)], randint(10, 30)]
        case _:
            print("None")
            return None


for path in list_of_paths:
    l = []
    for file_name in listdir(path):
        parse = parser(path.replace("./", "", 1))
        l.append({"image_path": f"assets{path.replace('.','')}{file_name}",
                  "product_name": file_name.replace(".jpg", ""),
                  "original_price": parse[2],
                  "remise": randint(15, 53),
                  "rating_value": random() * 3.5 + 1,
                  "mark": file_name.split(maxsplit=1)[0],
                  "stock_size": randint(20, 80),
                  "size": parse[0],
                  "colors": parse[1]
                  })
    json_map.__setitem__("-".join(path.replace("./", "").split("/")[:3]), l)
dump(json_map, finaljson)

print("phase 1 done")

"""for dir in ["./informatique/accessoires/", "./informatique/ordinateur/", "./informatique/phone/", "./informatique/stockage/"]:
    for image in listdir(dir):
        with open(dir+image, 'rb') as i:
            with open(dir+image.replace(".jpg", "_.jpg", 1), 'wb') as o:
                input = i.read()
                output = remove(input)
                o.write(output)"""

"""for dir in ["./informatique/accessoires/", "./informatique/ordinateur/", "./informatique/phone/", "./informatique/stockage/"]:
    for image in listdir(dir):
        
        if "_.jpg" in image:
            rename(dir+image, (dir+image).replace("_.jpg", ".jpg"))
        else:
            remove(dir+image)
print("phase 2 done")"""
"""
from os import listdir
from PIL import Image
list_of_paths = ["./female/dress/", "./female/glasses/", "./female/hat/", "./female/hijab/", "./female/pants/",
                 "./female/shirts/", "./female/shoes/", "./male/hats/", "./male/pants/", "./male/shirts/",
                 "./male/shoes/", "./male/sunglasses/", "./child/dress/", "./child/pants/", "./child/shirts/", "./child/shoes/",
                 "./informatique/accessoires/", "./informatique/ordinateur/", "./informatique/phone/", "./informatique/stockage/"]

for dir in list_of_paths:
    for image in listdir(dir):
        img = Image.open(dir+image)
        img = img.resize(img.size, Image.LANCZOS)
        img.save(dir+image)
for item in [*[f"./{i}.jpg" for i in range(6)],"./bg.jpg","./icognito.jpg"]:
    img = Image.open(image)
    img = img.resize(img.size, Image.ANTIALIAS)
    img.save(image)

"""