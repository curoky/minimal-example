/*
 * Copyright (c) 2018-2024 curoky(cccuroky@gmail.com).
 *
 * This file is part of minimal-example.
 * See https://github.com/curoky/minimal-example for further info.
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

#define EIGEN_USE_GPU
#include "tensorflow/core/framework/op.h"
#include "tensorflow/core/framework/op_kernel.h"
#include "tensorflow/core/framework/shape_inference.h"
#include "tensorflow/core/public/version.h"
#include "tensorflow/core/util/gpu_kernel_helper.h"
#include "tensorflow/core/util/gpu_launch_config.h"
#include "unsupported/Eigen/CXX11/Tensor"

namespace tensorflow {

REGISTER_OP("AddOne")
    .Input("input: int32")
    .Output("output: int32")
    .SetShapeFn([](::tensorflow::shape_inference::InferenceContext* c) {
      c->set_output(0, c->input(0));
#if TF_MAJOR_VERSION == 2 && TF_MINOR_VERSION > 5
      return OkStatus();
#else
      return Status::OK();
#endif
    })
    .Doc(R"doc(
Adds 1 to all elements of the tensor.

output: A Tensor.
  output = input + 1
)doc");

typedef Eigen::ThreadPoolDevice CPUDevice;
typedef Eigen::GpuDevice GPUDevice;
namespace functor {
template <typename Device>
struct AddOneFunctor {
  static Status Compute(OpKernelContext* context,
                        const typename TTypes<int32_t, 1>::ConstTensor& input,
                        typename TTypes<int32_t, 1>::Tensor& output);
};
template <>
struct AddOneFunctor<CPUDevice> {
  static Status Compute(OpKernelContext* context,
                        const typename TTypes<int32_t, 1>::ConstTensor& input,
                        typename TTypes<int32_t, 1>::Tensor& output) {
    const int N = input.size();
    std::cout << "AddOneFunctor on cpu, size=" << N << std::endl;
    for (int i = 0; i < N; i++) {
      output(i) = input(i) + 1;
    }
#if TF_MAJOR_VERSION == 2 && TF_MINOR_VERSION > 5
    return OkStatus();
#else
    return Status::OK();
#endif
  }
};

__global__ void AddOneKernel(const int* in, const int N, int* out) {
  for (int i = blockIdx.x * blockDim.x + threadIdx.x; i < N; i += blockDim.x * gridDim.x) {
    out[i] = in[i] + 1;
  }
}

template <>
struct AddOneFunctor<GPUDevice> {
  static Status Compute(OpKernelContext* context,
                        const typename TTypes<int32_t, 1>::ConstTensor& input,
                        typename TTypes<int32_t, 1>::Tensor& output) {
    const int N = input.size();
    std::cout << "AddOneFunctor on gpu, size=" << N << std::endl;
    TF_CHECK_OK(::tensorflow::GpuLaunchKernel(AddOneKernel, 32, 256, 0, nullptr, input.data(), N,
                                              output.data()));
#if TF_MAJOR_VERSION == 2 && TF_MINOR_VERSION > 5
    return OkStatus();
#else
    return Status::OK();
#endif
  }
};
}  // namespace functor

template <typename Device>
class AddOneOp : public OpKernel {
 public:
  explicit AddOneOp(OpKernelConstruction* context) : OpKernel(context) {}

  void Compute(OpKernelContext* context) override {
    // Grab the input tensor
    const Tensor& input_tensor = context->input(0);
    auto input = input_tensor.flat<int32>();

    // Create an output tensor
    Tensor* output_tensor = nullptr;
    OP_REQUIRES_OK(context, context->allocate_output(0, input_tensor.shape(), &output_tensor));
    auto output = output_tensor->template flat<int32>();
    functor::AddOneFunctor<Device> add_one;
    OP_REQUIRES_OK(context, add_one.Compute(context, input, output));
    std::cout << "AddOneOp done" << std::endl;
  }
};

REGISTER_KERNEL_BUILDER(Name("AddOne").Device(DEVICE_CPU), AddOneOp<CPUDevice>);
REGISTER_KERNEL_BUILDER(Name("AddOne").Device(DEVICE_GPU), AddOneOp<GPUDevice>);

}  // namespace tensorflow
