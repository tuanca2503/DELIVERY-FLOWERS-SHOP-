//// Lấy URL của trang hiện tại
//var url = window.location.href;
//// Tách chuỗi URL thành các phần tử
//var NoHttp = url.split("://")

//var parts = NoHttp[1].split("/");

//// Xóa phần tử cuối cùng (tên trang)
////parts.pop();
//// Tạo breadcrumb
//var breadcrumb = document.getElementById("chrome-breadcrumb");
//var html = "<div><nav aria-label='breadcrumbs' class='_1MMuO3r'><ol class='q0MjRbt'>";
//for (var i = 0; i < parts.length; i++) {
//    // Tạo link cho các phần tử trừ phần tử cuối cùng"<span>" + parts[i] + "</span>"
//    if (i < parts.length - 1) {
//        if (i == 0) {
//            html += "<li><a href='" + parts.slice(0, i + 1).join("/") + "'>" + parts[i] + "</a></li>";
//            continue;
//        }
//        html += "<li><span aria-hidden='true'>›</span><a href='" + parts.slice(0, i + 1).join("/") + "'>" + parts[i] + "</a></li>";
//    }
//    // Thêm phần tử cuối cùng vào breadcrumb
//    else {
//        html += "<li><span aria-hidden='true'>›</span><span>" + parts[i] + "</span></li>";
//    }

//}
//html += "</ol></nav></div>"
//breadcrumb.innerHTML = html;