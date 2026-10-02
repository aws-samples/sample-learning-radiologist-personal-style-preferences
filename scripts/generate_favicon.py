"""
Generate favicon and PWA icons for the Flutter web app.

Creates professional "RP" monogram icons in multiple sizes:
- favicon.png (32x32) - browser tab icon
- Icon-192.png, Icon-512.png - standard PWA icons
- Icon-maskable-192.png, Icon-maskable-512.png - adaptive PWA icons with safe zone

Design: Navy-to-teal gradient circle with white "RP" text, matching the login logo.
"""

from pathlib import Path
from PIL import Image, ImageDraw, ImageFont
import math
import sys


# Color scheme matching AppTheme (frontend-web/lib/config/app_theme.dart)
NAVY = "#1B2A4A"
TEAL = "#00897B"
WHITE = "#ffffff"

# Typography - using default font, will look for system fonts
FONT_SIZES = {
    32: 18,
    192: 110,
    512: 290,
}


def hex_to_rgb(hex_color: str) -> tuple:
    """Convert hex color to RGB tuple."""
    hex_color = hex_color.lstrip("#")
    return tuple(int(hex_color[i : i + 2], 16) for i in (0, 2, 4))


def lerp_color(c1: tuple, c2: tuple, t: float) -> tuple:
    """Linearly interpolate between two RGB colors."""
    return tuple(int(c1[i] + (c2[i] - c1[i]) * t) for i in range(3))


def get_font(size: int):
    """Get the best available bold font for the given size."""
    font_names = [
        # macOS bold fonts
        "/System/Library/Fonts/Supplemental/Arial Bold.ttf",
        "/System/Library/Fonts/Helvetica.ttc",
        "/System/Library/Fonts/SFNSDisplay.ttf",
        # Windows
        "arialbd.ttf",
        "Arial.ttf",
        # Linux
        "DejaVuSans-Bold.ttf",
    ]

    for font_name in font_names:
        try:
            return ImageFont.truetype(font_name, size)
        except (OSError, IOError):
            continue

    # Fallback to default font
    return ImageFont.load_default()


def create_gradient_circle(size: int) -> Image.Image:
    """
    Create a circular image with a top-left to bottom-right gradient
    from navy to teal, matching the login logo style.
    """
    navy_rgb = hex_to_rgb(NAVY)
    teal_rgb = hex_to_rgb(TEAL)

    # Work at higher resolution for anti-aliasing, then downscale
    scale = 4
    hi_size = size * scale
    img = Image.new("RGBA", (hi_size, hi_size), (0, 0, 0, 0))
    pixels = img.load()

    center = hi_size / 2.0
    radius = hi_size / 2.0
    # Diagonal length for gradient normalization (top-left to bottom-right)
    diag = math.sqrt(2) * hi_size

    for y in range(hi_size):
        for x in range(hi_size):
            # Check if pixel is inside the circle
            dx = x - center + 0.5
            dy = y - center + 0.5
            dist = math.sqrt(dx * dx + dy * dy)

            if dist <= radius:
                # Gradient: top-left (0,0) = navy, bottom-right (size,size) = teal
                t = (x + y) / diag
                t = max(0.0, min(1.0, t))
                r, g, b = lerp_color(navy_rgb, teal_rgb, t)

                # Anti-alias edge pixels
                if dist > radius - scale:
                    alpha = max(0, min(255, int(255 * (radius - dist) / scale)))
                else:
                    alpha = 255

                pixels[x, y] = (r, g, b, alpha)

    # Downscale with high-quality resampling for smooth edges
    img = img.resize((size, size), Image.LANCZOS)
    return img


def create_icon(size: int, maskable: bool = False) -> Image.Image:
    """
    Create an icon image with "RP" monogram on a gradient circle.

    Args:
        size: Icon dimensions (square)
        maskable: If True, add safe zone padding for maskable icons

    Returns:
        PIL Image object
    """
    # Create transparent background
    img = Image.new("RGBA", (size, size), (0, 0, 0, 0))

    # For maskable icons, the circle is smaller (80% safe zone)
    if maskable:
        circle_size = int(size * 0.7)
    else:
        circle_size = size

    # Create gradient circle
    circle = create_gradient_circle(circle_size)

    # Paste circle centered on canvas
    offset = (size - circle_size) // 2
    img.paste(circle, (offset, offset), circle)

    # Draw text
    draw = ImageDraw.Draw(img)

    # Calculate font size
    if size in FONT_SIZES:
        font_size = FONT_SIZES[size]
    else:
        font_size = int(size * 0.56)

    if maskable:
        font_size = int(font_size * 0.7)

    font = get_font(font_size)
    text = "RP"

    # Get text bounding box
    bbox = draw.textbbox((0, 0), text, font=font)
    text_width = bbox[2] - bbox[0]
    text_height = bbox[3] - bbox[1]

    # Center text on the icon
    x = (size - text_width) // 2 - bbox[0]
    y = (size - text_height) // 2 - bbox[1]

    # Draw white text
    draw.text((x, y), text, fill=hex_to_rgb(WHITE), font=font)

    return img


def main():
    """Generate all required icon files."""
    # Get project root (parent of scripts dir)
    script_dir = Path(__file__).parent
    project_root = script_dir.parent
    web_dir = project_root / "frontend-web" / "web"
    icons_dir = web_dir / "icons"

    # Create icons directory if it doesn't exist
    icons_dir.mkdir(parents=True, exist_ok=True)

    print("Generating favicon and PWA icons...")
    print(f"Output directory: {web_dir}")
    print()

    # Generate favicon (32x32)
    print("Creating favicon.png (32x32)...")
    favicon = create_icon(32)
    favicon.save(web_dir / "favicon.png", "PNG", optimize=True)
    print("✓ favicon.png created")

    # Generate standard PWA icons
    print("\nCreating standard PWA icons...")
    for size in [192, 512]:
        print(f"Creating Icon-{size}.png...")
        icon = create_icon(size)
        icon.save(icons_dir / f"Icon-{size}.png", "PNG", optimize=True)
        print(f"✓ Icon-{size}.png created")

    # Generate maskable PWA icons (with safe zone + white background)
    print("\nCreating maskable PWA icons (with safe zone)...")
    for size in [192, 512]:
        print(f"Creating Icon-maskable-{size}.png...")
        icon = create_icon(size, maskable=True)
        # Maskable icons need opaque background for platform rendering
        bg = Image.new("RGBA", (size, size), (255, 255, 255, 255))
        bg.paste(icon, (0, 0), icon)
        bg.save(icons_dir / f"Icon-maskable-{size}.png", "PNG", optimize=True)
        print(f"✓ Icon-maskable-{size}.png created")

    print("\n" + "=" * 60)
    print("✓ All icons generated successfully!")
    print("=" * 60)
    print("\nGenerated files:")
    print(f"  - {web_dir / 'favicon.png'}")
    print(f"  - {icons_dir / 'Icon-192.png'}")
    print(f"  - {icons_dir / 'Icon-512.png'}")
    print(f"  - {icons_dir / 'Icon-maskable-192.png'}")
    print(f"  - {icons_dir / 'Icon-maskable-512.png'}")
    print("\nNext steps:")
    print("  1. Test locally: cd frontend-web && flutter run -d chrome")
    print("  2. Check browser tab for favicon")
    print("  3. Open DevTools > Application > Manifest to verify PWA icons")
    print("  4. Deploy: cd cdk && uv run cdk deploy FrontendStack")


if __name__ == "__main__":
    try:
        main()
    except Exception as e:
        print(f"Error: {e}", file=sys.stderr)
        sys.exit(1)
