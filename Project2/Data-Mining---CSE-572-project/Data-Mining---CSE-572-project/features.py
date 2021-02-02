import numpy as np
import pywt
from numpy.fft import fft
from sklearn.decomposition import PCA


class Features:
    def __init__(self, data_frame):
        self.df = data_frame
        self.feature_matrix = []
        self.max_points_per_series = 4
        self.pca = None
        self.decomposed_feature_matrix = None

    def compute_features(self):
        for idx, row in self.df.iterrows():
            feature_vector = []

            # cgm velocity
            cgm_velocity = [0]
            for index in range(len(row)-1):
                cgm_velocity += [row[index+1]-row[index]]
            cgm_velocity.sort(reverse=True)

            feature_vector += cgm_velocity[:self.max_points_per_series]

            # moving rms
            cgm_rms_moving = []
            for i in range(len(row)-5):
                sum_window = sum([x*x for x in row[i:i+5]])
                sum_window /= 5
                rms_window = sum_window**0.5
                cgm_rms_moving.append(rms_window)
            cgm_rms_moving.sort(reverse=True)
            feature_vector += cgm_rms_moving[:self.max_points_per_series]

            # discrete wavelet transform
            (cgm_dwt_approx, cgm_dwt_detail) = pywt.dwt(data=row, wavelet='db1', mode='sym')
            cgm_dwt_approx = cgm_dwt_approx.tolist()
            cgm_dwt_approx.sort(reverse=True)

            feature_vector += cgm_dwt_approx[:self.max_points_per_series]

            # fft
            cgm_fft = np.abs(fft(row))
            cgm_fft = cgm_fft.tolist()
            cgm_fft.sort(reverse=True)

            feature_vector += cgm_fft[:self.max_points_per_series]
            if not np.isnan(feature_vector).any():
                self.feature_matrix.append(feature_vector)

        self.normalize_features()

    def get_features(self):
        return self.feature_matrix

    def normalize_features(self):
        self.feature_matrix = np.array(self.feature_matrix)
        self.feature_matrix /= self.feature_matrix.sum(axis=1)[:, np.newaxis]
        self.feature_matrix = self.feature_matrix.tolist()

    def pca_decomposition(self):
        self.pca = PCA(n_components=5, random_state=43)
        self.decomposed_feature_matrix = self.pca.fit_transform(self.feature_matrix)
        return self.decomposed_feature_matrix







