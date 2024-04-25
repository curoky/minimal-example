/*
 * Copyright (c) 2018-2023 curoky(cccuroky@gmail.com).
 *
 * This file is part of learn-build-system.
 * See https://github.com/curoky/learn-build-system for further info.
 *
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *     http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */
#include <iostream>

#define CUDA_CHECK(expr)                                                     \
  do {                                                                       \
    cudaError_t err = (expr);                                                \
    if (err != cudaSuccess) {                                                \
      fprintf(stderr, "CUDA Error Code  : %d\n     Error String: %s\n", err, \
              cudaGetErrorString(err));                                      \
      exit(err);                                                             \
    }                                                                        \
  } while (0)

int main() {
  int deviceCount;
  CUDA_CHECK(cudaGetDeviceCount(&deviceCount));
  std::cout << "deviceCount: " << deviceCount << std::endl;
  for (int i = 0; i < deviceCount; i++) {
    cudaDeviceProp devProp;
    CUDA_CHECK(cudaGetDeviceProperties(&devProp, i));
    std::cout << "# GPU device " << i << ": " << devProp.name << std::endl;
    std::cout << "-> totalGlobalMem: " << devProp.totalGlobalMem / 1024 / 1024 << "MB" << std::endl;
    std::cout << "-> SM count" << devProp.multiProcessorCount << std::endl;
    std::cout << "-> sharedMemPerBlock: " << devProp.sharedMemPerBlock / 1024.0 << " KB"
              << std::endl;
    std::cout << "-> maxThreadsPerBlock: " << devProp.maxThreadsPerBlock << std::endl;
    std::cout << "-> regsPerBlock: " << devProp.regsPerBlock << std::endl;
    std::cout << "-> maxThreadsPerMultiProcessor: " << devProp.maxThreadsPerMultiProcessor
              << std::endl;
    std::cout << "-> maxThreadsPerMultiProcessor: " << devProp.maxThreadsPerMultiProcessor / 32
              << std::endl;
    std::cout << "-> multiProcessorCount: " << devProp.multiProcessorCount << std::endl;
  }
  return 0;
}
