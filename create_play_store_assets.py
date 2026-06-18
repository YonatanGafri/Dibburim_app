from PIL import Image, ImageFilter
import os

def create_play_store_assets():
    input_path = 'assets/images/icon.png'
    try:
        img = Image.open(input_path).convert('RGB')
    except Exception as e:
        print(f"Error opening image: {e}")
        return

    # 1. Create 512x512 App Icon
    icon = img.resize((512, 512), Image.Resampling.LANCZOS)
    icon_path = 'assets/images/play_store_icon.png'
    icon.save(icon_path, 'PNG')
    icon_size_kb = os.path.getsize(icon_path) / 1024
    print(f"Created {icon_path} (512x512) - {icon_size_kb:.2f} KB")

    # 2. Create 1024x500 Feature Graphic
    # Create blurred background
    # Resize width to 1024. The height will be 1024 * (1254/1254) = 1024.
    bg = img.resize((1024, 1024), Image.Resampling.LANCZOS)
    # Crop to 1024x500 (center)
    top = (1024 - 500) // 2
    bottom = top + 500
    bg = bg.crop((0, top, 1024, bottom))
    # Blur it
    bg = bg.filter(ImageFilter.GaussianBlur(radius=30))

    # Darken the background slightly so the center image pops more
    bg = bg.point(lambda p: p * 0.7)

    # Resize main image to height 500 (aspect ratio 1:1 -> 500x500)
    fg = img.resize((500, 500), Image.Resampling.LANCZOS)

    # Paste fg onto bg in the center
    left = (1024 - 500) // 2
    bg.paste(fg, (left, 0))

    feature_path = 'assets/images/play_store_feature_graphic.png'
    bg.save(feature_path, 'PNG')
    feature_size_kb = os.path.getsize(feature_path) / 1024
    print(f"Created {feature_path} (1024x500) - {feature_size_kb:.2f} KB")

if __name__ == '__main__':
    create_play_store_assets()
