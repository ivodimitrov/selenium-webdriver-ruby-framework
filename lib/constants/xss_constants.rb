class XSSConstants
  PAYLOADS =
    ['<video src=x onerror=alert(1);>',
     "<img src=x onerror='alert(2)'>",
     '<script>alert(3)</script>',
     '<svg/OnlOad=prompt(4)>',
     'javascript:alert(5)'].freeze
end
