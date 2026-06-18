import sys
from PIL import Image, ImageDraw

def make_adaptive():
    try:
        img = Image.open('assets/images/icon.png').convert('RGBA')
    except Exception as e:
        print("Error opening icon:", e)
        return

    # Get edge color (top left pixel)
    bg_color = img.getpixel((0, 0))
    print("Background color:", bg_color)
    
    # Adaptive icons expect a 108dp x 108dp image where the inner 72dp x 72dp is the safe zone.
    # This means the image needs to be padded by (108-72)/2 = 18dp on each side.
    # Ratio of padded to original: 108 / 72 = 1.5
    
    padded_size = int(img.width * 1.5)
    padded_img = Image.new('RGBA', (padded_size, padded_size), bg_color)
    offset = (padded_size - img.width) // 2
    padded_img.paste(img, (offset, offset))
    
    padded_img.save('assets/images/icon_adaptive_foreground.png')
    
    # Save the hex color to a file to use in pubspec
    hex_color = '#{:02x}{:02x}{:02x}'.format(bg_color[0], bg_color[1], bg_color[2])
    with open('bg_color.txt', 'w') as f:
        f.write(hex_color)

make_adaptive()
