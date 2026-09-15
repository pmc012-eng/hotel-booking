/**
 * Wrapper bọc các hàm controller bất đồng bộ để tự động chuyển lỗi tới next(err)
 * Tránh việc phải lặp lại try-catch thủ công trong từng controller
 */
const catchAsync = (fn) => {
  return (req, res, next) => {
    fn(req, res, next).catch(next);
  };
};

module.exports = catchAsync;
