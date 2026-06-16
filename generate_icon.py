from PIL import Image, ImageDraw, ImageFont
import os

width, height = 1024, 1024
image = Image.new('RGB', (width, height))
draw = ImageDraw.Draw(image)

for y in range(height):
    r = int(135 + (y/height)*(220-135))
    g = int(206 + (y/height)*(240-206))
    b = int(250 + (y/height)*(255-250))
    draw.line([(0, y), (width, y)], fill=(r, g, b))

try:
    font = ImageFont.truetype('arialbd.ttf', 250)
except IOError:
    font = ImageFont.load_default()

text = '\u05DD\u05D9\u05E8\u05D5\u05D1\u05D9\u05D3'
bbox = draw.textbbox((0, 0), text, font=font)
text_width = bbox[2] - bbox[0]
text_height = bbox[3] - bbox[1]

x = (width - text_width) / 2
y = (height - text_height) / 2 - 40

draw.text((x, y), text, fill='#042e60', font=font)

os.makedirs('assets/images', exist_ok=True)
image.save('assets/images/icon.png')
print('Icon saved')
