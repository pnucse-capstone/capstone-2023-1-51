from PIL import Image
import matplotlib.pyplot as plt
import glob
import csv
import pandas as pd


def get_image_size(folder_path):
    # 이미지 너비 정보 저장할 리스트
    image_widths = []

    files = glob.glob(folder_path + '/*.png')

    # 각 이미지의 너비 정보 추출
    for file in files:
        image = Image.open(file)
        image_width, _ = image.size
        image_widths.append(image_width)

    return image_widths


def save_to_csv(image_widths, csv_filename):
    with open(csv_filename, 'w', newline='') as csvfile:
        writer = csv.writer(csvfile)
        writer.writerow(["Image_widths"])
        for size in image_widths:
            writer.writerow([size])


def plot_image_sizes_histogram(image_widths):
    # 히스토그램 그래프 그리기
    plt.hist(image_widths, bins=20, color='blue', alpha=0.7)
    plt.xlabel('Image Width')
    plt.ylabel('Frequency')
    plt.title('Image Width Distribution')
    plt.grid(True)
    plt.show()


def create_frequency_table(csv_filename, num_bins):
    sizes = []

    with open(csv_filename, 'r') as csvfile:
        reader = csv.reader(csvfile)
        next(reader)
        for row in reader:
            sizes.append(int(row[0]))

    # pandas 데이터프레임 생성
    df = pd.DataFrame(sizes, columns=["File Size"])

    freq_table = pd.cut(df["File Size"], bins=num_bins).value_counts().sort_index()
    return freq_table


def sort_csv(input_filename, output_filename):
    # CSV 파일을 읽어서 데이터를 리스트로 저장합니다.
    data = []
    with open(input_filename, 'r') as csvfile:
        csvreader = csv.reader(csvfile)
        header = next(csvreader)  # 헤더를 건너뜁니다.
        for row in csvreader:
            data.append(int(row[0]))  # 각 행의 값을 정수로 변환하여 저장합니다.

    # 데이터를 정렬합니다.
    sorted_data = sorted(data)

    # 정렬된 데이터를 새로운 CSV 파일에 씁니다.
    with open(output_filename, 'w', newline='') as csvfile:
        csvwriter = csv.writer(csvfile)
        csvwriter.writerow(header)  # 헤더를 쓰고
        csvwriter.writerows([[val] for val in sorted_data])  # 정렬된 데이터를 씁니다.