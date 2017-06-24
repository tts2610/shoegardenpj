/* 
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */

$(document).ready(function () {

    var count = document.getElementsByClassName("countcmt");

    for (var i = 1; i <= count.length; i++) {
        var currentRating = $('#comment #fs-rating-star-results-' + i).data('current-rating');
        $('#comment #fs-rating-star-results-' + i).barrating({
            theme: 'fontawesome-stars-o',
            initialRating: currentRating,
            showSelectedRating: false,
            readonly: true
        });
    }

    $("#comment").on("change", "#fs-status-select", function () {
        var status = $(this).val();
        var rateID = $(this).attr("fs-comment");

        $.ajax({
            url: "admin/comments/updateStatus.html",
            method: "POST",
            data: {rateID: rateID, status: status},
            success: function (response) {
//                swal("UPDATE SUCCESS", response, "success");
                swal({
                    type: "success",
                    title: "UPDATE SUCCESS",
                    text: response,
                    timer: 2000,
                    showConfirmButton: false
                });

            }
        });
    });

});
