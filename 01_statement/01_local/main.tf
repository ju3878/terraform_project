provider "local" {   
} 

resource "local_file" "foo" { 
    filename = "${path.module}/foo.txt"  
    content = data.local_file.bar.content
    #content = "${path.module}/bar.txt"
}

// 입력 파일
data "local_file" "bar" {
    filename = "${path.module}/bar.txt"
}

// 출력 파일
// output "foo" {
// }
