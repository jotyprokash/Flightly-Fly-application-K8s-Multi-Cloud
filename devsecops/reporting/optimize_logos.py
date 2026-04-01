import os
from PIL import Image, ImageOps

logo_dir = "/home/jatri/Desktop/Flightly-Fly-application-K8s-Multi-Cloud/devsecops/reporting/logos"
target_size = (256, 256)

def optimize_image(filename):
    filepath = os.path.join(logo_dir, filename)
    name, ext = os.path.splitext(filename)
    
    # Open and convert to RGBA (for transparency)
    try:
        with Image.open(filepath) as img:
            img = img.convert("RGBA")
            
            # Create a transparent background canvas
            canvas = Image.new("RGBA", target_size, (255, 255, 255, 0))
            
            # Resize image maintaining aspect ratio
            img.thumbnail(target_size, Image.Resampling.LANCZOS)
            
            # Center the image on the canvas
            offset = ((target_size[0] - img.size[0]) // 2, (target_size[1] - img.size[1]) // 2)
            canvas.paste(img, offset, img)
            
            # Save as PNG
            canvas.save(os.path.join(logo_dir, f"{name}.png"), "PNG")
            
            # If we converted from another format, delete the original
            if ext.lower() not in [".png"]:
                os.remove(filepath)
                print(f"Optimized and converted {filename} to {name}.png")
            else:
                print(f"Optimized {filename}")
                
    except Exception as e:
        print(f"Error processing {filename}: {e}")

if __name__ == "__main__":
    for filename in os.listdir(logo_dir):
        if filename.lower().endswith((".png", ".jpg", ".jpeg", ".webp")):
            optimize_image(filename)
