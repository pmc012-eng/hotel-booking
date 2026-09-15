/**
 * Chuẩn hóa format JSON phản hồi từ API
 */

/**
 * Phản hồi thành công chuẩn
 */
function sendSuccess(res, data = null, message = 'Success', statusCode = 200) {
  return res.status(statusCode).json({
    status: 'success',
    message,
    data,
  });
}

/**
 * Phản hồi lỗi chuẩn
 */
function sendError(res, message = 'An error occurred', statusCode = 500, errors = null) {
  const response = {
    status: `${statusCode}`.startsWith('4') ? 'fail' : 'error',
    message,
  };

  if (errors) {
    response.errors = errors;
  }

  return res.status(statusCode).json(response);
}

/**
 * Phản hồi danh sách kèm phân trang
 */
function sendPaginated(res, items, total, page = 1, limit = 10, message = 'Success') {
  const totalPages = Math.ceil(total / limit);
  return res.status(200).json({
    status: 'success',
    message,
    data: items,
    pagination: {
      total,
      page: parseInt(page, 10),
      limit: parseInt(limit, 10),
      totalPages,
      hasNext: page < totalPages,
      hasPrev: page > 1,
    },
  });
}

module.exports = {
  sendSuccess,
  sendError,
  sendPaginated,
};
