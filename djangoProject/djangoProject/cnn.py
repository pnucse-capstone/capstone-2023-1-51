import numpy as np
import pandas as pd
import tensorflow as tf
from keras.layers import Input, DepthwiseConv2D, Conv2D, concatenate, GlobalMaxPooling2D, Dense
from keras.preprocessing.image import ImageDataGenerator
import keras.callbacks
from sklearn.metrics import classification_report, confusion_matrix
from sklearn.model_selection import train_test_split


def depthwise_separable_conv_block(input_layer, kernel_size):
    x = DepthwiseConv2D(kernel_size, padding='same', activation='relu')(input_layer)
    x = Conv2D(10, 1, activation='relu')(x)
    return x


def build_cnn_model(input_shape):
    input_layer = Input(shape=input_shape)

    # 크기별 Depthwise Convolution 연산 수행
    x = depthwise_separable_conv_block(input_layer, (1, 1))
    conv_blocks = [x]
    for kernel_size in range(2, 11):
        x = depthwise_separable_conv_block(x, (1, kernel_size))
        conv_blocks.append(x)

    # 연산 결과 합치기
    concatenated = concatenate(conv_blocks, axis=-1)
    conv = Conv2D(64, (1, 3), padding='same', activation='relu')(concatenated)

    gmp = GlobalMaxPooling2D()(conv)
    # Fully Connected 및 Output 레이어
    fc1 = Dense(256, activation='relu')(gmp)
    output = Dense(1, activation='sigmoid')(fc1)

    # 모델 생성
    model = tf.keras.Model(inputs=input_layer, outputs=output)
    return model


def load_data(image_path):
    # 데이터 로딩 및 전처리 설정
    data_generator = ImageDataGenerator(
        rescale=1.0 / 255
    )

    generator = data_generator.flow_from_directory(
        image_path,
        target_size=(1, 10000),
        batch_size=32,
        class_mode='binary',  # 클래스 모드 변경
    )

    all_images = []
    all_labels = []
    for _ in range(len(generator)):
        batch_images, batch_labels = generator.next()
        all_images.extend(batch_images)
        all_labels.extend(batch_labels)

    # NumPy 배열로 변환
    X = np.array(all_images)
    y = np.array(all_labels)

    # train, validation, test로 나누기
    X_train, X_temp, y_train, y_temp = train_test_split(X, y, test_size=0.3, random_state=42)
    X_val, X_test, y_val, y_test = train_test_split(X_temp, y_temp, test_size=0.5, random_state=42)

    return X_train, X_val, X_test, y_train, y_val, y_test


def cnn():
    image_path = './images/'
    X_train, X_val, X_test, y_train, y_val, y_test = load_data(image_path)

    # 모델 구축
    input_shape = (1, 10000, 3)  # 이미지의 입력 형태 설정
    model = build_cnn_model(input_shape)

    # 모델 컴파일
    model.compile(optimizer='adam', loss='binary_crossentropy', metrics=['accuracy'])  # 손실 함수 변경

    # 모델 요약 정보 출력
    model.summary()

    es = keras.callbacks.EarlyStopping(patience=3, restore_best_weights=True)
    # 모델 학습
    history = model.fit(X_train, y_train,
                        epochs=1000,
                        validation_data=(X_val, y_val),
                        callbacks=[es]
                        )

    history_df = pd.DataFrame(history.history)
    history_df.to_csv('history.csv', index=False)

    # 모델 저장
    model.save('my_model1.h5')
    print(model.evaluate(X_test, y_test))

    y_pred = model.predict(X_test)
    y_pred_binary = np.array(y_pred) >= 0.5

    print(classification_report(y_test, y_pred_binary))
    print(confusion_matrix(y_test, y_pred_binary))
