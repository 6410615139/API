import subprocess
import argparse
import os

def convert_mov_to_gif(input_file, output_file, fps, width):
    command = [
        'ffmpeg',
        '-i', input_file,
        '-filter_complex', f"[0:v] fps={fps},scale={width}:-1:flags=lanczos,split [a][b];[a] palettegen [p];[b][p] paletteuse",
        '-c:v', 'gif',
        output_file
    ]
    subprocess.run(command)

def main():
    parser = argparse.ArgumentParser(description='Convert a .mov file to a .gif file.')
    parser.add_argument('input_file', type=str, help='The input .mov file')
    parser.add_argument('output_file', nargs='?', type=str, help='The output .gif file (optional)')
    parser.add_argument('--fps', type=int, default=32, help='Frames per second for the output GIF (default: 32)')
    parser.add_argument('--width', type=int, default=720, help='Width of the output GIF, height is adjusted to maintain aspect ratio (default: 720)')

    args = parser.parse_args()

    # Generate the output filename based on the input filename if not provided
    if not args.output_file:
        base_name = os.path.splitext(args.input_file)[0]
        args.output_file = f"{base_name}.gif"

    convert_mov_to_gif(args.input_file, args.output_file, args.fps, args.width)

if __name__ == "__main__":
    main()
