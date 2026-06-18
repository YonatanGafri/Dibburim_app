from PIL import Image
import sys

try:
    img = Image.open('assets/images/icon.png')
    print(f"Original size: {img.size}")
    print(f"Top-left pixel: {img.getpixel((0,0))}")
except Exception as e:
    print(f"Error: {e}")
    sys.exit(1)
